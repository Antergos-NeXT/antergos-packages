loadTemplate("org.kde.plasma.desktop.defaultPanel")

var desktopsArray = desktopsForActivity(currentActivity());
for( var j = 0; j < desktopsArray.length; j++) {
    desktopsArray[j].wallpaperPlugin = 'org.kde.image';
    desktopsArray[j].currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];
    desktopsArray[j].writeConfig('Image', 'file:///usr/share/backgrounds/antergos/antergos-wallpaper.png');
    desktopsArray[j].writeConfig('FillMode', 2);
}
