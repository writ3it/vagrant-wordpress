# =================== #
# BEGIN CONFIGURATION #
# =================== #

# Set your theme name
THEME_NAME="your_theme"
THEME_NICENAME="Your theme"

# Blog

HOST='10.10.10.10'
BLOG_TITLE="Hello wordpress!"
BLOG_ADMIN_LOGIN="admin"
BLOG_ADMIN_PASSWORD="admin"
BLOG_ADMIN_EMAIL="example@example.com"
WP_LOCALE="en_US"


# Database settings
DB_NAME="wordpressdb"
DB_USERNAME="wordpressusr"


# ================= #
# END CONFIGURATION #
# ================= #
Vagrant.configure("2") do |config|
    config.vm.box = "generic/ubuntu2004"

    config.vm.provision "shell", privileged: true, path:  ".provision/preinstallation.sh"

    config.vm.network "private_network", ip: HOST
    config.vm.network "forwarded_port", guest: 80, host: 80, auto_correct: true
    config.vm.usable_port_range = 80..90

    config.vm.synced_folder ".", "/srv/theme/"

    config.vm.provision "shell" do |sh|
        sh.path =  ".provision/database.sh"
        sh.privileged = true
        sh.args = [DB_NAME, DB_USERNAME]
    end

    config.vm.provision "shell" do |sh|
        sh.path =  ".provision/php.sh"
        sh.privileged = true
    end

    config.vm.provision "shell", privileged: true, path:  ".provision/php.sh"
    config.vm.provision "shell", privileged: true, path: ".provision/apache.sh"

    config.vm.provision "shell" do |sh|
        sh.path = ".provision/wordpress.sh"
        sh.args = [THEME_NAME, THEME_NICENAME, DB_NAME, DB_USERNAME, HOST,BLOG_TITLE, BLOG_ADMIN_LOGIN, BLOG_ADMIN_PASSWORD, BLOG_ADMIN_EMAIL, WP_LOCALE]
    end

    config.vm.provision "shell" do |sh|
        sh.path = ".provision/install.sh"
        sh.args = [THEME_NAME]
    end
end