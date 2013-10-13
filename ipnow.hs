module Main (
    main, start
) where
-- Systemwide imports
import Graphics.UI.Gtk.MenuComboToolbar.ImageMenuItem
import Graphics.UI.Gtk.Abstract.Box as ABox
import Graphics.UI.Gtk.Multiline.TextBuffer
import Graphics.UI.Gtk.Multiline.TextView
import Graphics.UI.Gtk.Display.Image
import Graphics.UI.Gtk.Entry.Entry
import Graphics.UI.Gtk.Buttons.Button
import Graphics.UI.Gtk.Builder
import Graphics.UI.Gtk
import Data.Maybe
import Graphics.UI.Gtk.General.RcStyle

import System.IO
import System.Cmd
import System.Process
--local imports

-- ############# FUNCTIONS ##############

getnsetip interface ipfirstbytes snmask = do
    ipfirsttext <- entryGetText ipfirstbytes
    let ip_string = (ipfirsttext) 
    putStrLn $ "IP string:" ++ ip_string
    mask_string <- entryGetText snmask
    setip interface ip_string mask_string



setip interface ip snmask = do
    --execute something like   ifconfig eth0 192.168.1.45 up
    let ifdown_cmd_string = "ifconfig " ++ interface ++ " down"
    let cmd_string = "ifconfig " ++ interface ++ " " ++  ip ++ " up"
    putStrLn $ "cmd string: "  ++ cmd_string
    _ <- system $ "ifconfig " ++ interface
    _ <- system $ ifdown_cmd_string
    _ <- system $ cmd_string

    --re-add the gateway, because it was removed
    let add_gateway_cmd_string = "route add default gw 192.168.1.1 " ++ interface
    _ <- system $ add_gateway_cmd_string
    _ <- system $ "ifconfig " ++ interface
    putStrLn $ "Tried to set IP:" ++ ip ++ " Subnet:" ++ snmask



createMainGUI = do
    --load gladefile
    builder <- builderNew
    builderAddFromFile builder "./gtk/ipnow.glade"
    
    --getEntryfields
    ipfirstbytes <- builderGetObject builder castToEntry "ipfirstbytes"
    entrySetWidthChars ipfirstbytes 14 --11
    snmask <- builderGetObject builder castToEntry "snmask"    
    entrySetWidthChars snmask 12

    --set defaults    
    let interface = "eth0"
    interfacelable <- builderGetObject builder castToLabel "interface_name_lbl"
    labelSetText interfacelable interface

    --get current ip and set
    current_ip      <- readProcess "./currentifconfig.sh" [interface,"ip"] []
    current_snmask  <- readProcess "./currentifconfig.sh" [interface, "subnet"] []
    entrySetText ipfirstbytes current_ip 
    entrySetText snmask current_snmask

    --register event for set button
    setbtn <- builderGetObject builder castToButton "setbtn"
    onClicked setbtn $ getnsetip interface ipfirstbytes snmask

    --window managment
    main_window <- builderGetObject builder castToWindow "main_window"
    onDestroy main_window mainQuit
    widgetShowAll main_window



-- #########         MAIN           ##############
start= main
main = do
    --rcParse "../gtk/gtkrc-2.0-ipnow"        -- STYLE if wished
    initGUI                                 -- GTK INIT
    main_gui <- createMainGUI               -- GUI CONSTRUCTION
    mainGUI                                 -- START 

