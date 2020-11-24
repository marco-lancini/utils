# Add with relationship
`CREATE (p:Person)-[:LIKES]->(t:Technology)`

# Add nodes, then link them
```
CREATE (friend:Person {name: 'Mark'})

MATCH (jennifer:Person {name: 'Jennifer'})
MATCH (mark:Person {name: 'Mark'})
CREATE (jennifer)-[rel:IS_FRIENDS_WITH]->(mark)
```

# Add with no duplicates
`MERGE (mark:Person {name: 'Mark'})`

# Update node
```
MATCH (p:Person {name: 'Jennifer'})
SET p.birthdate = date('1980-01-01')
```

# Update relationship
```
MATCH (:Person {name: 'Jennifer'})-[rel:WORKS_FOR]-(:Company {name: 'Neo4j'})
SET rel.startYear = date({year: 2018})
RETURN rel
```

# Delete
```
MATCH (j:Person {name: 'Jennifer'})-[r:IS_FRIENDS_WITH]->(m:Person {name: 'Mark'})
DELETE r
```
Delete all nodes:
```
MATCH (n) DETACH DELETE n;
MATCH (n) DELETE n;
```

# Find (complete)
```
MATCH (p:Person {name: "Jennifer"})-[rel:LIKES]->(g:Technology {type: "Graphs"}) RETURN p.name AS PersonName
```

# Other Resources
* Filter query results: [https://neo4j.com/developer/filtering-query-results/](https://neo4j.com/developer/filtering-query-results/)
* Additional resources: [https://neo4j.com/docs/cypher-refcard/current/](https://neo4j.com/docs/cypher-refcard/current/)  