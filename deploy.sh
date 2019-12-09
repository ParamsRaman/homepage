#!/bin/sh

#To build and run the website locally, uncomment the below two lines:
#jekyll build
#jekyll serve
#open -a "Google Chrome" "http://127.0.0.1:4000/~praman1"


##To build and deploy the website to a remote server (modify the server details as per your needs), uncomment the below two lines:

jekyll build

# To deploy to https://people.ucsc.edu/~praman1/ (use blue)
echo "Deploying to unix server (enter blue):"
rsync -vaz _site/ praman1@unix.ic.ucsc.edu:public_html

# To deploy to https://users.soe.ucsc.edu/~praman1 (use gold)
echo "Deploying to citrisdance server (enter gold):"
rsync -vaz _site/ praman1@citrisdance.soe.ucsc.edu:/soe/praman1/.html
