What it is:
    IpNow is a simple gui app that lets you change an ip address real quick written in Haskell
    Relying on a piece of bashscript
   
What it does:
    I gets the current ip and subnetmask from the ethernet lan interface eth0 to display it.
    Then on click of one button the changes are applied. 
    That is, the interface is downed, upped and the default gateway 192.168.1.1 is reinstalled.

Original purpose:
    On different situations of testing network settings or gui things, it might occure to change the ip address a lot. 
    Now changing it will be more easy.
    So far it needs to be run as root or with sudo. 
    Run the source with: runhaskell ipnow.hs,
    Run the binary: ./ipnow
    
Todo:
    enable wlan0 or any way of interface selection
