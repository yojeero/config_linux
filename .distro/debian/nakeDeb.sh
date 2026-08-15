sudo apt update
sudo apt upgrade

sudo apt install firefox-esr firefox-esr-l10n-ru

# В nakeDeb по умолчанию интегрированы утилиты для защиты глаз (фильтрация синего света), которые автоматически снижают цветовую температуру экрана. 

# В зависимости от версии nakeDeb за это отвечает демон утилиты sct (set screen color temperature) или служба redshift. 

# Откройте терминал и выполните команду, чтобы сбросить температуру на стандартные 6500K
sct 6500
 
# Redshift, просто закройте его:
killall redshift

# Как отключить эту функцию навсегда
.config/autostart/Redshift


