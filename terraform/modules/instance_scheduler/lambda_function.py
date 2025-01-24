import boto3
import os
from datetime import datetime, time, timezone, timedelta

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    instance_id = os.environ['INSTANCE_ID']

    # KST로 변환
    KST = timezone(timedelta(hours=9))
    current_time = datetime.now(KST).time()
    
    start_time = time(15, 50) # 5시 시작은 (5,0)
    stop_time = time(16, 20) # 11시 종료는 (11, 0)
    
    print(f"start_time {start_time}")
    print(f"current_time {current_time}")
    print(f"stop_time {stop_time}")

    if start_time <= stop_time:
        # Normal case where start_time and stop_time are on the same day
        if start_time <= current_time < stop_time:
            action = 'start'
        else:
            action = 'stop'
    else:
        # Case where stop_time is on the next day
        if start_time <= current_time or current_time < stop_time:
            action = 'start'
        else:
            action = 'stop'
    
    try:
        if action == 'start':
            response = ec2.start_instances(InstanceIds=[instance_id])
            print(f"Started instance {instance_id}")
        elif action == 'stop':
            response = ec2.stop_instances(InstanceIds=[instance_id])
            print(f"Stopped instance {instance_id}")
        
        return {
            'statusCode': 200,
            'body': f"Successfully {action}ed instance {instance_id}"
        }
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': f"Error {action}ing instance: {str(e)}"
        }