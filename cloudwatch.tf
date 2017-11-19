## Topic definition for alerting.
# If multiple resources exist for each server group, count needs to be updated to the value of the var that defines the number of instances
resource "aws_sns_topic" "critical_alerts" {
  name = "${var.environment}-critical-alerts"
  provisioner "local-exec" {
    command = <<EOT
    for email in ${var.critical_alerts_notification}; do
       aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint $email; 
    done
    EOT
  }
}

resource "aws_sns_topic" "non_critical_alerts" {
  name = "${var.environment}-non-critical-alerts"
  provisioner "local-exec" {
    command = <<EOT
    for email in ${var.critical_alerts_notification}
    do
       aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint $email; 
    done
    EOT
  }
}

# EC2 cloudwatch test Instance
resource "aws_cloudwatch_metric_alarm" "status_check_ec2_cloudwatch_test" {
  count = 1
  alarm_name                = "${var.environment}.ec2-cloudwatch-test.${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}.status-check-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "4"
  metric_name               = "StatusCheckFailed_System"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "1"
  alarm_description         = "This metric monitor ec2 status"
  actions_enabled           = true
  alarm_actions             = ["${aws_sns_topic.non_critical_alerts.arn}"]
  alarm_description         = "${var.environment}.ec2_cloudwatch_test id: ${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)} availability is degraded"
  ok_actions                = ["${aws_sns_topic.non_critical_alerts.arn}"]
  dimensions {InstanceId = "${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}" }
}

# Alert for Disk usage 
resource "aws_cloudwatch_metric_alarm" "disk_usage_ec2_cloudwatch_test" {
  count = 1
  alarm_name                = "${var.environment}.ec2_cloudwatch_test.${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}.disk-usage-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "5"
  metric_name               = "DiskSpaceUtilization"
  namespace                 = "System/Linux"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "60"
  alarm_description         = "This metric checks disk space usage"
  actions_enabled           = true
  alarm_actions             = ["${aws_sns_topic.non_critical_alerts.arn}"]
  alarm_description         = "${var.environment}.ec2_cloudwatch_test id: ${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)} low disk space on instance"
  ok_actions                = ["${aws_sns_topic.non_critical_alerts.arn}"]
  dimensions {InstanceId = "${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}" }
}

# Metric Alarm for CPU usage
resource "aws_cloudwatch_metric_alarm" "high_cpu_ec2_cloudwatch_test" {
  count = "1"
  alarm_name                = "${var.environment}.ec2_cloudwatch_test.${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}.high-cpu-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "20"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  actions_enabled           = true
  alarm_actions             = ["${aws_sns_topic.non_critical_alerts.arn}"]
  alarm_description         = "${var.environment}.ec2_cloudwatch_test id: ${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)} has high CPU usage"
  ok_actions                = ["${aws_sns_topic.non_critical_alerts.arn}"]
  dimensions {InstanceId = "${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}" }
}

# Metric Alarm for StatusCheckFailed_System
resource "aws_cloudwatch_metric_alarm" "status_check_failed_system" {
  count = "1"
  alarm_name                = "${var.environment}.ec2_cloudwatch_test.${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}.high-cpu-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed_System"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors StatusCheckFailed_System"
  actions_enabled           = true
  alarm_actions             = ["${aws_sns_topic.non_critical_alerts.arn}"]
  alarm_description         = "${var.environment}.ec2_cloudwatch_test id: ${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)} has check failed system"
  ok_actions                = ["${aws_sns_topic.non_critical_alerts.arn}"]
  dimensions {InstanceId = "${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}" }
}

# Metric Alarm for StatusCheckFailed_Instance
resource "aws_cloudwatch_metric_alarm" "status_check_failed_instance" {
  count = "1"
  alarm_name                = "${var.environment}.ec2_cloudwatch_test.${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}.high-cpu-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed_Instance"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors StatusCheckFailed_Instance"
  actions_enabled           = true
  alarm_actions             = ["${aws_sns_topic.non_critical_alerts.arn}"]
  alarm_description         = "${var.environment}.ec2_cloudwatch_test id: ${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)} has check failed instance"
  ok_actions                = ["${aws_sns_topic.non_critical_alerts.arn}"]
  dimensions {InstanceId = "${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}" }
}
