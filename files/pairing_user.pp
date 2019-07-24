$ensure = present

Ssh_authorized_key {
  ensure  => $ensure,
  user    => 'pairing',
  options => 'command="tmux -S /tmp/pairing-tmux.sock attach-session -t pairing"',
}

user { 'pairing':
  ensure         => $ensure,
  managehome     => true,
  home           => '/tmp/pairing',
  password       => '$1$1XmTZQbG$AGZBn3RKPzfoUZbya.Kh21', # Dangerous?
  purge_ssh_keys => true,
} ->
file { '/tmp/pairing':
  ensure => directory,
  owner  => 'pairing',
  group  => 'pairing',
}

ssh_authorized_key { 'tao':
  type => 'rsa',
  key  => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQCSq/ElK+XucRkAzecEZi5msjbZbt7eHtduMTpNQetvTROeEQJHVokYUh74UK2EfQ3mxfN36OsQ4dPiNcr5XkzoUXMUTlKaSIBoRZCZIYsEPGthI6PfaRqgnlNfYYz+bxl7BLGUm3Cr3q6CICXi9c1Tk1JF6/H8RbUtKEGLV1ADVrOQ/54Md/cj+Y9Z+O7ZIWHVanwpo/VNp0iv7t1zoWUuKeyexjFLj89q6vLZVo0UgBSRYuWfJbN5i4LzvqNTn5O/0AmeaFr/C4r5VVxMTFrG/p1hKworcFxNXOsNQwaGnGOHnjgVaSvQdXC9rXtDSM+RBzuzj65Sifqo8DqyguTMAABpschthObUV152LSl+NIOTXJQh4/B6miFlxWgA9rrCXn51VYMekFLpCDTWYqhfJccyaSaohrJifV2ImUDgfOBpCSsiowYZnqLIb22It1R+2szwzfuw35b7GZ5dAS3Szev6wRhmS8bvNsh2sGNr+CmV/QZrYK1rjRqWmICkq+cSo9HB8Q7bXtbjeGBxRyzE89pK2na8xxBS730Ieooq9c5s+JzXo7TAVPeMIpagXJRLFay/et3a8wLNzU/DZPPkKaxhSTm0jWj4RNJRxs2gOea+3voea/GVK/IWBhDHqYgCwBD2OgvEF2etQFs6mrPHVxBWqUGQRtO1XYJUYrluGw==',
}
