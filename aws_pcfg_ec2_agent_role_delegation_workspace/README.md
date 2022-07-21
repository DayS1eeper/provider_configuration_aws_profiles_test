Connect to instance:
```sh
chmod 600 linux-key-pair.pem
ssh -oStrictHostKeyChecking=no -i linux-key-pair.pem ubuntu@<ip of ec2 instance>
```