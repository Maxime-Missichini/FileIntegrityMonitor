# FileIntegrityMonitor

A file integrity (I in CIA) monitor using PowerShell. Inspired by Josh Madakor's video, go check his channel: https://youtu.be/WJODYmk4ys8 !

# Table of content
- Purpose
- Usage
- TO-DO

## Purpose
Making sure that files are not modified when they're not supposed to. 
Raise a warning message when :
- A file has been added to the folder
- A file has been modified inside the folder
- A file has been deleted from the folder

It works by computing hashes for each file (SHA-512 is used). Then we can easily see if the file has been modified since a single modification will completely change the hash. We use a dictionnary to store hashes and files paths. We compute all hashes every 1 minutes so maybe there is a more efficient way :).

## Usage
You can place all the files you want to monitor inside testFiles folder. 
First, you must place yourself where the script is located.
Then launch the script inside PowerShell using: 
<code>./fim.ps1</code>

You'll have to choose between creating a new baseline (a.k.a content of the dictionary) or launch monitoring.
If it's your first start, you must create a baseline typing 1 and then launch the script again and typing 2 to launch the monitoring.
Now the monitor will watch for any modification every 1s. It calculates hashes every seconds so be warned.

## TO-DO
[ ] - Secure inputs
[ ] - Add more hash algorithm (faster ?)
[ ] - Add email alerts or more flashy alerts
[ ] - Create more functions
[ ] - Implement baseline append
[ ] - Find a better way than checking every 1s
