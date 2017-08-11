# Aliases to manage AWS instances
alias awsup='aws ec2 start-instances --instance-ids "$AWS_INSTANCE_ID"'
alias awsdown='aws ec2 stop-instances --instance-ids "$AWS_INSTANCE_ID"'
alias awsstatus='aws ec2 describe-instances --instance-ids "$AWS_INSTANCE_ID" | jq ".Reservations[0].Instances[0].State.Name"'
