#!/usr/bin/env perl
 
package HelloWorld;
use Web::Simple;
use Plack::Request;
use Template;
 
sub dispatch_request {
  my ($self, $env) = @_;
  my $req = Plack::Request->new($env);

  sub (GET) {
    my $self = shift;
    [ 200, [ 'Content-type', 'text/html' ], [ $self->view('contact.tt') ] ];
  },
  sub (POST) {
    my $self = shift;
    my $params = $req->body_parameters;
    my $name = $params->{name};

    my $output = $self->view( 'contact.tt',
        posted => 1,
        name => $name,
    );
    [ 200, [ 'Content-type', 'text/html' ], [ $output ] ],
  }
}

sub view {
    my ($self, $template, %vars) = @_;
    
    my $tt = Template->new(
        INCLUDE_PATH => 'tt/',
    );

    my $output;
    $tt->process($template, \%vars, \$output);

    return $output;
}
 
HelloWorld->run_if_script;
