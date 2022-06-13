# **Adeel's PowerShell Scripts**
---
This repo contains scripts uploaded for public view.

**Script - AD User Onboarding.ps1**

This script will create an AD user. It will use another user's profile to copy groups and OU path. It will reduce the required steps to create a user to entering user first name, last name, copied from to generate the whole account. It will also output results for easy copy and paste

**Script - Hostname and Domain Join.ps1**

This script will generate a hostname for a windows device. It will prompt whether the device is a laptop or a desktop and add a serial at the end. Be warned it will continue past the NETBIOS hostname. It will then add it to the domain as well as put in the OU depending on whether it is a desktop or a laptop

**Script - MonthlyFolders.ps1**

A simple script that will generate a folder by year followed by subfolders with each month. 
