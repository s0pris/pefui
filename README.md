# pefui
<p><a href="https://pey.sh/">pey.sh's</a> enhanced figlet user interface</p>

![Alt text](https://github.com/s0pris/pefui/blob/main/1.png?raw=true)
![Alt text](https://github.com/s0pris/pefui/blob/main/2.png?raw=true)
<p>
pefui is a simple GUI interface for figlet using yad.
</p>

<p> <b><i>#todo: add a way to specific desired font</i></b></p>
<p>
manual installation:
</p>

<b>fedora systems:</b>

install figlet, yad, and git (if not already present)
```bash
sudo dnf install figlet yad git
```

make sure your in your home directory (or your desired directory, this guide will have you put but the fonts that go to /usr/share/figlet/ in that directory;
```bash
cd ~
```

clone the fonts: (this will create their own directories)
```bash
git clone https://github.com/s0pris/xeros-figlet-fonts
git clone https://github.com/s0pris/DoseOfGoses-Figlet-Fonts
```

we will use rsync for copying font files to /usr/share/filet/ :

```bash
sudo rsync -av xeros-figlet-fonts/ /usr/share/figlet/
sudo rsync -av DoseOfGoses-Figlet-Fonts/ /usr/share/figlet/
```


OPTION A: 

install pefui's installer; (this makes the actual pefui.sh file and makes a desktop file shortcut entry so you can launch it from your desktop from an icon.)

```bash
curl -LO https://github.com/s0pris/pefui/raw/main/pefui-install.sh
sudo chmod +x pefui-install.sh
```
run the installer:
```bash
./pefui-install.sh
```


OPTION B:

install the standalone pefui.sh script:

```bash
curl -LO https://github.com/s0pris/pefui/blob/main/pefui.sh
sudo chmod +x pefui.sh
```

and run it by:

```bash
./pefui.sh
```

