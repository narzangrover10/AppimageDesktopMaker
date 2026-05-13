#! /bin/bash

echo "Making \"Appimages\" folder in home/<username>/ directory. This is where the script will be and where you should put any .appimage files"
sleep 0.5

while true; do

    read -p "Enter \"y\" to continue, \"n\" to change the folder name, or \"p\" to change path: " folder_consent
    if [ $folder_consent = "y" ]; then
        mkdir ~/Appimages/
        appimages="~/Appimages/"
        echo "Appimages folder successfully created!"
        sleep 0.5
        break
    elif [ $folder_consent = "p" ]; then
        while true; do
            read -p "Enter your desired folder name or absolute path:" user_path
            if case "$user_path" in
                /*) pathchk -- "$user_path";;
                *) ! :;;
            esac
            then
                mkdir "${user_path}"
                appimages="$user_path"
                break
            else
                echo "Invalid Path. Please enter an absolute path (starting with /)"
            fi
            echo "$userpath folder successfully created!"
            sleep 0.5
            break
        done
        break
    else
        echo "Invalid input. Please enter \"y\", \"n\", \"p\""
        sleep 0.5
    fi
done

echo "Creating \"Drop Here.desktop\". Drop appimages onto this to create a launchable .desktop file for it"
touch $appimages/"Drop Here".desktop
drop_here="${appimages}/Drop Here.desktop"

cat >"${drop_here}" <<EOL
[Desktop Entry]
Exec=konsole -e "~/${appimages}/.appimagemaker.sh"
Icon=utilities-terminal
Name=Drop Here
Type=Application
EOL
cat "$drop_here"

sleep 0.5

echo "\"Drop Here.desktop\" successfully created in $appimages"
sleep 0.5

echo "Creating \".appimagemaker.sh\" to write the .desktop files"

touch $appimages/.appimagemaker.sh

script="$appimages/.appimagemaker.sh"
cat << 'EOF' > $script
#! /bin/bash

appimage=$1

read -p "Enter name of app: " appname
read -p "Enter file path of icon: " iconpath

if [[ ! -f "$iconpath" ]]; then
    echo "Error: Path or file does not exist"
    exit 1
fi

mime_type=$(file --mime-type -b "$iconpath")
if [[ $mime_type == image/* ]]; then
    echo "Icon path validated"
else
    echo "Error: File not an image."
    exit 1
fi

iconname=$(basename -- "$iconpath")
extension="${iconname##*.}"
iconname="${iconname%.*}"

mv "$iconpath" /home/nathan/.local/share/icons
touch ~/.local/share/applications/"${appname}".desktop
desktop="~/.local/share/applications/"${appname}".desktop"
cat >"${desktop}" <<EOL
[Desktop Entry]
Name=${appname}
Exec="${appimage}" %f
Icon=${iconname}
Type=Application
EOL

cat "${desktop}"

chmod +x "${desktop}"
chmod +x "${appimage}"

read -r
EOF

sleep 0.5

echo "Successfully created \".appimagemaker.sh\". This script is hidden by the \".\" prefix for the sake of cleanliness, so dont worry about not being able to see it."

sleep 0.5

echo "Setup is done! Feel free to delete this script (setup.sh) as it is not necessary anymore."

