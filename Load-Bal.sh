#!/bin/bash                                                                                                                                                     
set +o errexit                                                                                                                                                  
set +o pipefail                                                                                                                                                 
                                                                                                                                                                
# Ask the user for a number                                                                                                                                     
echo "How many times do you want to repeat the function?"                                                                                                       
read num                                                                                                                                                        
                                                                                                                                                                
# Define the function                                                                                                                                           
function repeat_function() {                                                                                                                                    
        docker run -d -it --network bexus -p 8$i:80 --name container$i ubuntu tail -f dev/null                                                                  
                                                                                                                                                                
        docker exec container$i apt-get update                                                                                                                  
        docker exec container$i sh -c export TZ=America/New_York                                                                                                
        docker exec container$i sh -c DEBIAN_FRONTEND=noninteractive                                                                                            
        docker exec container$i apt-get install -y tzdata                                                                                                       
        docker exec container$i apt-get install -y php-fpm || true                                                                                              
        docker exec container$i apt-get install -y nginx                                                                                                        
        docker exec container$i apt-get install -y php                                                                                                          
        docker exec container$i apt-get install -y wget                                                                                                         
        docker exec container$i apt-get install -y net-tools                                                                                                    
        docker exec container$i sh -c "service nginx start"                                                                                                     
        docker exec container$i sh -c "rm /etc/nginx/sites-available/default"                                                                                   
        docker exec container$i sh -c  "wget -P /etc/nginx/sites-available/ https://raw.githubusercontent.com/testingthisgithubshit/script-test/main/default"   
        docker exec container$i sh -c "rm -rf /var/www/html/*"                                                                                                  
        docker exec container$i sh -c "wget -P /var/www/html/ https://raw.githubusercontent.com/testingthisgithubshit/script-test/main/index.php"               
        docker exec container$i sh -c "nginx -s reload"                                                                                                         
        docker exec container$i php-fpm8.1                                                                                                                      
                                                                                                                                                                
# Define the text to search for                                                                                                                                 
search_text="server 127.0.0.1:81;"                                                                                                                              
                                                                                                                                                                
# Define the new line to add after the search text                                                                                                              
new_line="      server 127.0.0.1:8$i;"                                                                                                                          
                                                                                                                                                                
# Define the path to the file to modify                                                                                                                         
file_path="/etc/nginx/nginx.conf"                                                                                                                               
                                                                                                                                                                
# Use sed to replace the search text with the search text and the new line                                                                                      
sed -i "s/$search_text/$search_text\n$new_line/g" "$file_path"                                                                                                  
}                                                                                                                                                               
                                                                                                                                                                
# Call the function using a for loop                                                                                                                            
for ((i=1; i<=num; i++))                                                                                                                                        
do                                                                                                                                                              
  repeat_function &                                                                                                                                             
done                                                                                                                                                            
wait                                                                                                                                                            
                                                                                                                                                                
                                                                                                                                                                
echo "$num_containers containers created."                                                                                                                      
                                                                                                                                                                
echo "Now here are the IP Addresses of all the containers :"                                                                                                    
for (( i=1; i<=$num; i++ ))                                                                                                                                     
do                                                                                                                                                              
echo ">> Container $i : $(docker exec container$i ifconfig eth0 | grep 'inet ' | awk '{print $2}')"                                                             
done                                                                                                                                                            