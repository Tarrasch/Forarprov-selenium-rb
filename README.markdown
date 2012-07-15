## Automatized checking of available drivers test times (in Sweden)

Tired of manually checking every 5 minutes if a interesting test time is
available at `fp.vv.se`? Then definitely check this out!

This is a small ruby script using the selenium webdriver tool to
automate the manual labor of constantly checking for available spots.

### Preparations

#### Your credentials

    cp user.yml{.sample,}
    vim user.yml

Put in words, remove the `.sample` from `user.yml.sample` and edit the
file and write in your real credentials.

#### Installing ruby and selenium bindings

Make sure you have `ruby` installed somehow, and then install the
`selenium-webdriver` gem. If you're unfamiliar with gems, this means to
just issue

    gem install selenium-webdriver

If that doesn't work and you don't care for installing gems properly, you
can try

    sudo gem install selenium-webdriver

Only the later worked for me on a clean ubuntu installation.

#### Non ubuntu users

For those not having the `notify-send` command, you must edit the method
`notify_user` to send some user notification that a interesting booking
have been found.

#### Ubuntu (and partially linux) users

To get `ogg123` which will enable sounds, issue

    sudo apt-get install vorbis-tools

To notify a user on the screen (in case sound i muted or not working), I use
the `notify-send` command which I believe only exists on Ubuntu systems.

### Usage

    ruby korning-selenium.rb

This should fire up a firefox window that will do everything for you.
After you've found a time (perhaps after finding out from a sent
notification). Just continue directly from the browser window. The
driver will crash and stop messing with the browser as soon as you as a
user go on to book your reservation.

This all worked for me during the summer of 2012, their web site might
look different in the future.
