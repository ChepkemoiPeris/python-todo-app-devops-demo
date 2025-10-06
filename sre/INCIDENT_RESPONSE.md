# Incident Response Procedures

## 1. TodoAppDown Alert

**Severity:** Critical
**Response Time:** Immediate

### Steps:
1. Check pod status:
    ```bash
    kubectl get pods -l app=todo-app
    ```

2. Check pod logs:
    ```bash
    kubectl logs -l app=todo-app --tail=100
    ```

3. Check recent events:
    ```bash
    kubectl get events --sort-by='.lastTimestamp' | grep todo-app
    ```

4. If pods are CrashLooping:
    ```bash
    kubectl describe pod <pod-name>
    ```

5. Check resource usage:
  ```bash
  kubectl top pods -l app=todo-app
  ```

6. Rollback if recent deployment:
    ```bash
    kubectl rollout undo deployment/todo-app-deployment
    ```

## 2. DatabaseConnectionFailed Alert

**Severity:** Critical
**Response Time:** Immediate

### Steps:
1. Check RDS instance if available via console or aws cli 

2. Check todo-app pods logs:
  ```bash
    kubectl get pods -l app=todo-app
    ```

3. Verify secrets are correct:
    ```bash
    kubectl get secret db-secrets -o yaml
    ```

4. Test connection from todo pod:
    ```bash
    kubectl exec -it <todo-pod> -- curl http://eks-url-endpoint:5000/healthz
    ```

## 3. HighErrorRate Alert

**Severity:** Warning
**Response Time:** 15 minutes

### Steps:
1. Check application logs for errors:
    ```bash
    kubectl logs -l app=todo-app --tail=200 | grep -i error
    ```
2. Check Grafana dashboard for error patterns

3. Verify database connectivity

4. Check if specific endpoint is failing

5. Review recent code changes

6. Consider scaling if resource-related:
    ```bash
    kubectl scale deployment/todo-app --replicas=4
    ```
## 4. Notifications & Escalation
   - Alerts are sent to the #alerts channel on Slack through Alertmanager.

   - Critical alerts (e.g., AppDown, DatabaseConnectionFailed) should be acknowledged immediately in Slack.

   - If not resolved within 15 minutes, escalate to the on-call engineer.

   - Keep communication updates in the same Slack thread for visibility.

## 5. Post-Incident Review
After resolving a critical alert:
- Document root cause and resolution in INCIDENT_LOG.md.
- Identify any missing alerts or false positives.
- Update runbooks or alert thresholds if needed.
- Discuss learnings during weekly review.

## 6. Improvement 
- Integrate email or AWS SNS/SES for secondary alert delivery.

- Automate runbook actions (e.g., restart pods on CrashLoop).

- Add synthetic monitoring using Blackbox Exporter.

- Implement uptime SLIs and SLOs in Grafana.

- Add incident tracking automation (e.g., Jira or PagerDuty integration).