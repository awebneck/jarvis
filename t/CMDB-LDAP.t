use Test::More tests => 8;
BEGIN { 
        unshift(@INC,"../lib") if -d "../lib"; 
        unshift(@INC,"lib") if -d "lib"; 
        use_ok('CMDB::LDAP');
      }

################################################################################
# construtcor tests 
my $results =  {
                 'uri'    => 'ldaps://odin.websages.com:636, ldaps://freyr.websages.com:636',
                 'basedn' => 'dc=websages,dc=com',
                 'binddn' => 'uid=whitejs,ou=People,dc=websages,dc=com',
                 'bindpw' => $ENV{'BINDDN'},
               };

my $style = [
              {
                'uri'    => 'ldaps://odin.websages.com:636, ldaps://freyr.websages.com:636',
                'basedn' => 'dc=websages,dc=com',
                'binddn' => 'uid=whitejs,ou=People,dc=websages,dc=com',
                'bindpw' => $ENV{'BINDDN'},
              },

              {
                'domain'   => 'websages.com',
                'uid'      => 'whitejs',
                'bindou'   => 'People',
                'password' => $ENV{'BINDDN'},
              },

              {
                'domain'   => 'websages.com',
                'uid'      => 'whitejs',
                'password' => $ENV{'BINDDN'},
              },

              {
                'uid'      => 'whitejs@websages.com',
                'password' => $ENV{'BINDDN'},
              },

              {
                'creds'    => "whitejs\@websages.com:$ENV{'BINDDN'}",
              },

              {
                'creds'    => "whitejs:$ENV{'BINDDN'}",
              },

            ];
for(my $x=0; $x<=$#{ $style }; $x++){
    my $cmdb = CMDB::LDAP->new($style->[$x]);
    is_deeply($cmdb->bind_data, $results, "constructor style_$x") ||
      print Data::Dumper->Dump([$style->[$x],$cmdb->bind_data, $results]);
}

my $anonbind = {
                 'uri'    => 'ldaps://odin.websages.com:636, ldaps://freyr.websages.com:636',
                 'basedn' => 'dc=websages,dc=com',
                 'binddn' => undef,
                 'bindpw' => undef,
               };

my $cmdb = CMDB::LDAP->new({});
is_deeply($cmdb->bind_data, $anonbind, "bind_anonymously") ||
      print Data::Dumper->Dump([{},$cmdb->bind_data, $anonbind]);

