change web-sg to private for terraform reference

postgre - added another private subnet
create db subnet group with private ones
add inbound rule 5432 -> from the web.sg

elasticache
create subnet group
create inbound rule 6379

cloudfront
create files
echo "DUMMYDUMMYDUMMY" > dummy{0001..0100}.c