
echo
/usr/local/bin/brew shellenv 2>/dev/null || /opt/homebrew/bin/brew shellenv || /home/linuxbrew/.linuxbrew/bin/brew shellenv

test -d $HOME/perl5 || PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5

export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
