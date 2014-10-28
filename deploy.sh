#!/bin/sh

#To build and run the website locally, uncomment the below two lines:
#jekyll build
#jekyll serve


#To build and deploy the website to a remote server (modify the server details as per your needs), uncomment the below two lines:
jekyll build
rsync -vaz _site/ praman1@unix.ic.ucsc.edu:public_html
