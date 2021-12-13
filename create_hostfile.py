line1 = "[servers]\n"

with open("terraform/public_ip.txt") as f:
    line2 = f.readline()

line3 = "\n[servers:vars]\n"
line4 = "ansible_connection=ssh\n"
line5 = "ansible_user=ubuntu"

with open('ansible/hosts','w') as out:
    out.writelines([line1, line2, line3, line4, line5])