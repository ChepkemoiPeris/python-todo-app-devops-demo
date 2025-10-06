# Setup observability for flask app deloyed on EKS
- We are going to setup observability for our flask app deployed to eks. EKS was setup using terraform. Check the /terraform and /k8s for manifest files and connecting to eks via kube-config
- Prometheus collects metrics from various sources (Kubernetes nodes, pods, services) using 
  exporters and stores them in time-series data format.
- Grafana connects to Prometheus as a data source and visualizes the collected metrics in 
  user-friendly dashboards.
- Alerts are configured in Prometheus to notify users when certain thresholds are breached.
## Prerequisites  
   - EKS cluster running
   - Flask app deployed
   - kubectl configured
   - Helm installed

## Steps to setup prometheus and grafana for flask app
1. Update Your Flask Application:
   - Update requirements.txt - add prometheus-flask-exporter
   - Update your Flask app (app.py) - You can get full code on /app/app.py:
      ```bash
      from prometheus_flask_exporter import PrometheusMetrics
      #then after app do
      metrics = PrometheusMetrics(app)
      ```
   - Rebuild and push docker image or if you followed cicd steps just push code to github and it
      will rebuid image and redeploy application
   - Test the metrics endpoint - access metrics via /metrics endpoint so http://your-address/metrics.You should see Prometheus metrics output.

2. Install Prometheus and Grafana
   - Add Helm repositories
      ```bash
      helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
      helm repo update
      ```
   - Create monitoring namespace
      ```bash
      kubectl create namespace monitoring
      ```
   -  Install the kube-prometheus-stack
      ```bash
      helm install prometheus prometheus-community/kube-prometheus-stack \
      --namespace monitoring \
      --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
      --set grafana.adminPassword=admin123
      ```
      This will install:
         - Prometheus (metrics collection)
         - Grafana (visualization)
         - Alertmanager (alert handling)
         - Node exporter (server metrics)
         - Kube-state-metrics (Kubernetes metrics)
   - Verify installation
      ```bash
      kubectl get pods -n monitoring
      ```
      You should see pods like: - prometheus-prometheus-kube-prometheus-prometheus-0 and others.Wait until all pods show Running state.

3. Configure Prometheus to Monitor Your Flask App
    - Create a ServiceMonitor - Create a todo-servicemonitor.yaml file on k8s/ folder. You can copy code from my k8s/todo-servicemonitor.yaml. Make sure your match labels matches your service app: labels, if you don't have it update service.yaml - metadata: labels: app: todo-app
    - Apply the configurations
      ```bash
      # Apply the ServiceMonitor
      kubectl apply -f todo-servicemonitor.yaml

      # Verify it was created
      kubectl get servicemonitor -n monitoring
      ```
    - Verify Prometheus is scraping your app(Optional)
      ```bash
      # Port forward to Prometheus
      kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090
      ```
      Open browser to http://localhost:9090/targets and look for your todo-app target. It should show as "UP".

4. Configure Alerts
   - Create alert rules file - Create a file called todo-alerts.yaml on k8s/ folder and get code from my k8s/todo-alerts.yaml
   - Apply alert rules: 
      ```bash
      kubectl apply -f todo-alerts.yaml
      ```
   - Verify alerts are loaded(Optional)
      ```bash
      # Port forward to Prometheus
      kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090
      ```
      Visit http://localhost:9090/alerts to see your configured alerts.

5. Setup Grafana Dashboard
   - Access grafana:
     ```bash 
     kubectl edit svc prometheus-grafana -n monitoring 
     ```
     Then change:
     Change `type: ClusterIP` to `type: LoadBalancer`  
     ```bash
     spec:
      type: LoadBalancer
     ```
     Wait few second then check:
     ```bash
     kubectl get svc -n monitoring prometheus-grafana
     ```
     Copy the EXTERNAL-IP and access it directly on browser:

     Get password via:
     ```bash
     kubectl get secret prometheus-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
     ``` 
      - Username: admin
      - Password: {passwordfromcommandabove}

   - Add Prometheus data source
      - Click on (Settings) -> Data Sources
      - Prometheus should already be configured
      - Test the connection
   - Create a new dashboard
      Click + -> Dashboard -> Add new panel/visualization:

      - Panel 1: Todo Application Status
         - Visualization: Stat
         - Query: up{job="todo-app-svc"}
         - Title: "Todo Application Status"

      - Panel 2: Todo Request Rate
         - Visualization: Time series
         - Query: sum(rate(flask_http_request_total[5m])) by (status)
         - Title: "Request Rate by Status Code"

      - Panel 3: Todo Response Time
         - Visualization: Time series
         - Query: histogram_quantile(0.95, sum(rate(flask_http_request_duration_seconds_bucket[5m])) by (le))
         - Title: "95th Percentile Response Time"

      - Panel 4: Todo Error Rate
         - Visualization: Stat
         - Query: (sum(rate(flask_http_request_total{status=~"5.."}[5m])) / sum(rate(flask_http_request_total[5m]))) * 100
         - Title: "Error Rate %"
         - Thresholds: Green < 1%, Yellow < 5%, Red >= 5%

      - Panel 5: Todo Database Health
         - Visualization: Stat
         - Query: db_connection_health
         - Title: "Database Connection Status"
         
      - Panel 6: Pod CPU Usage
         - Visualization: Time series
         - Query: sum(rate(container_cpu_usage_seconds_total{pod=~"flask-app-.*"}[5m])) by (pod)
         - Title: "CPU Usage by Pod"

      - Panel 7: Pod Memory Usage
         - Visualization: Time series
         - Query: sum(container_memory_usage_bytes{pod=~"flask-app-.*"}) by (pod)
         - Title: "Memory Usage by Pod"
      Save dashboard after every entry.

6. Configure Alertmanager Notifications(Optional)
    We are going to setup/configure Slack notifications
    - Get Slack Webhook URL
      - Sign in to slack or sign up if you don't have an account
      - Go to: https://api.slack.com/messaging/webhooks
      - Click "Create New App" → "From scratch"
      - Name it "Prometheus Alerts", choose your workspace
      - Click "Incoming Webhooks" → Turn it ON
      - Click "Add New Webhook to Workspace"
      - Choose a channel (or creat a new one #alerts)
      - Copy the webhook URL (looks like: https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXX)

    - Create alertmanager-config.yaml on k8s/ folder and get code from this repo k8s/alertmanager-config.yaml and replace api_url with your value.

    - Apply and Test
      ```bash
      # Apply
      kubectl apply -f alertmanager-config.yaml

      # Restart alertmanager
      kubectl rollout restart statefulset/alertmanager-prometheus-kube-prometheus-alertmanager -n monitoring

      # Test - trigger an alert
      kubectl scale deployment/flask-app --replicas=0

      # Wait 2 minutes, check Slack!

      # Scale back
      kubectl scale deployment/flask-app --replicas=2
      ```
   Email can be added via SMTP or AWS SES as a future improvement for production environments.

7. Test Your Monitoring Setup
   - Test normal operation -  Generate some traffic to your application and Check Grafana to see 
      the metrics update.
      ```bash      
      for i in {1..100}; do
      curl http://your-flask-app-url/
      done
      ```
   - Test alerts: Simulate app down
      ```bash
      kubectl scale deployment/flask-app --replicas=0
      ```
      Check if you received alerts or check on http://your-url:9090/alerts
   - Restore the app
      ```bash
      kubectl scale deployment/flask-app --replicas=2
      ```
   - Test alert: Simulate database failure
      change the host name or db_name to nonexistent, and recheck then restore the database connection
   
## Notes
   - Incident response procedures are on INCIDENT_RESPONSE.md
   - You can improve this by setting notifications to use SES or SNS