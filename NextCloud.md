#### Edit *config.php* file:
```
sudo nano /home/<USER>/NextCloud/files/config/config.php
```
  
    
#### Slow login, edit: *'overwrite.cli.url' => ...*
```
# change to (if using domain):
'overwrite.cli.url' => 'https://example.com', 'overwritehost' => 'example.com', 'overwriteprotocol' => 'https',
# or (if subdomain):
'overwrite.cli.url' => 'https://cloud.example.com', 'overwritehost' => 'cloud.example.com', 'overwriteprotocol' => 'https',
```
#### Default landing app after login, add at the end:*
```
'defaultapp' => 'files',
# ...
  'installed' => true,
  'instanceid' => 'ocjoficzuewq',
  'defaultapp' => 'files',
);
```
