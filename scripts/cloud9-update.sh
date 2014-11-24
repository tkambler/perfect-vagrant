#!/bin/bash
#
# Cloud9 was improperly configured in the original `cloud9.sh` script. This script
# fixes those issues.

# Kill improperly configured instance
supervisorctl stop cloud9
ps aux | grep [n]ode | awk '{print $2}' | xargs kill -9

mkdir /home/vagrant/projects
cat << 'EOF' > /home/vagrant/projects/.settings
<settings time="1416838145579"><general animateui="true" revealfile="false" confirmexit="false" automergeenabled="false" dontaskautomerge="false" autosaveenabled="false" saveallbeforerun="false"><keybindings preset="auto"/></general><auto><menus minimized="false"/><tabs show="true"/><panels active="ext/tree/tree"><panel path="ext/settings/settings" width="250"/><panel path="ext/openfiles/openfiles" width="130"/><panel path="ext/tree/tree" width="200"/><panel path="ext/runpanel/runpanel" width="270"/></panels><tree_selection path="/workspace" type="folder"/><projecttree>["/workspace"]</projecttree><customtypes/><statusbar show="true"/><console autoshow="true" clearonrun="false" showinput="true"/><node-version version="auto"/><configurations debug="false" autohide="true"   ><config name=" (active file)" curfile="1" last="true"/></configurations><help show="true"/></auto><editors><code stripws="false" overwrite="false" selectstyle="line" activeline="true" gutterline="true" showinvisibles="false" showprintmargin="true" showindentguides="true" printmargincolumn="80" behaviors="true" wrapbehaviors="false" softtabs="true" tabsize="4" scrollspeed="2" fontsize="12" wrapmode="false" wraplimitmin="" wraplimitmax="" wrapmodeViewport="true" gutter="true" folding="true" newlinemode="auto" highlightselectedword="true" autohidehorscrollbar="true" fadefoldwidgets="true" animatedscroll="true" behaviorsdefaulted="true" keyboardmode="default"/><codewidget colorpicker="false"/></editors><breakpoints   /><beautify><jsbeautify preserveempty="true" keeparrayindentation="false" jslinthappy="false" braces="end-expand" space_before_conditional="true" unescape_strings="true"/></beautify><language jshint="true" instanceHighlight="true" undeclaredVars="true" unusedFunctionArgs="false" continuousCompletion="false"/><preview running_app="false"/></settings>
EOF
chown -R vagrant:vagrant /home/vagrant/projects

cat << 'EOF' > /opt/cloud9/bin/cloud9.sh
#!/bin/sh

ME=`readlink "$0" || echo "$0"`
cd `dirname "$ME"`/..

make worker

case `uname -a` in
Linux*x86_64*)  echo "Linux 64 bit"
	print "hey"
    exec node server.js "$@" -a x-www-browser
    ;;

Linux*i686*)  echo "Linux 32 bit"
    exec node server.js "$@" -a x-www-browser
    ;;

*) echo "Unknown OS"
   ;;
esac
EOF

mv /opt/cloud9 /home/vagrant/
rm /home/vagrant/cloud9/.sessions/*

chown -R vagrant:vagrant /home/vagrant/cloud9

cat << 'EOF' > /etc/supervisor/conf.d/cloud9.conf
[program:cloud9]
command=/home/vagrant/cloud9/bin/cloud9.sh -w /home/vagrant/projects -l 0.0.0.0
directory=/home/vagrant/projects
autostart=true
autorestart=true
startretries=3
stderr_logfile=/var/log/cloud9/cloud9.err.log
stdout_logfile=/var/log/cloud9/cloud9.out.log
user=vagrant
EOF

supervisorctl reread
supervisorctl update

supervisorctl stop cloud9
supervisorctl start cloud9
