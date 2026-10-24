def ip_to_bin(ip_str):
    """Chuyển đổi IP dạng 192.168.1.1 sang dạng bit 32-bit (dạng integer)"""
    octets = [int(x) for x in ip_str.split('.')]
    return (octets[0] << 24) + (octets[1] << 16) + (octets[2] << 8) + octets[3]

def bin_to_ip(ip_int):
    """Chuyển đổi integer 32-bit ngược lại dạng chuỗi IP"""
    return f"{(ip_int >> 24) & 255}.{(ip_int >> 16) & 255}.{(ip_int >> 8) & 255}.{ip_int & 255}"

def calculate_subnet(cidr_str):
    ip_part, mask_part = cidr_str.split('/')
    prefix = int(mask_part)
    
    # Tính Subnet Mask nhị phân
    mask_int = (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF
    
    # IP nhị phân
    ip_int = ip_to_bin(ip_part)
    
    # Tính toán các thông số
    net_int = ip_int & mask_int
    bcast_int = net_int | (~mask_int & 0xFFFFFFFF)
    
    first_host = net_int + 1
    last_host = bcast_int - 1
    
    print(f"CIDR Input        : {cidr_str}")
    print(f"Network Address   : {bin_to_ip(net_int)}")
    print(f"Broadcast Address : {bin_to_ip(bcast_int)}")
    print(f"Host Range        : {bin_to_ip(first_host)} -> {bin_to_ip(last_host)}")
    print(f"Subnet Mask       : {bin_to_ip(mask_int)}")

# Chạy thử
calculate_subnet("192.168.1.50/24")