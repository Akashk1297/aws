endpoint_dict={}
with open('pipeline/src/file.log') as f:
    for line in f:
        #print(line)
        parts=line.strip().split(" ")
        date=parts[0]
        timestamp=parts[1]
        operation=parts[2]
        endpoint=parts[3]
        statusCode=parts[4]

        if(endpoint_dict.get(endpoint)):
            prev=endpoint_dict.get(endpoint)
            endpoint_dict[endpoint]=1+int(prev)
        else:
            endpoint_dict[endpoint]=1

print('Result: ',endpoint_dict)
