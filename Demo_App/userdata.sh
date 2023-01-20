#!/bin/bash

    sudo yum install java-1.8.0-openjdk -y
    sudo yum install maven -y
    sudo yum install git -y
    sudo yum install mysql -y
    cd /home/ec2-user
    sudo git clone https://github.com/Smruthi01/Webapp-BE.git
    cd Webapp-BE
    mvn spring-boot:run
    
    # for rds connection - host name txt file
spring boot app accesing screts from aws sm 

    #       user_data = <<EOF
#       #!/bin/bash

#       echo "from pvt instance"
      
#       sudo yum install java-1.8.0-openjdk -y
#       sudo yum install maven -y
#       sudo yum install git -y
#       sudo yum install mysql -y
#       cd /home/ec2-user
#       sudo git clone https://github.com/Smruthi01/Webapp-BE.git
#       cd Webapp-BE
#       mvn spring-boot:run

#    EOF