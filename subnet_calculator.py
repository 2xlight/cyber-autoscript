#!/usr/bin/env python3
"""
subnet_calculator.py
------------------------------------------------------------------
Subnet calculator viết bằng tay, KHÔNG dùng module `ipaddress`/
`socket` (thứ sẽ làm sẵn hết việc này). Chỉ dùng phép toán bit
(<<, >>, &, |, ^) và string thuần Python - mục đích là hiểu rõ CÁCH
1 địa chỉ IP + prefix biến thành network/broadcast/host range ở
tầng bit, thứ mà `ipaddress` đang giấu bên trong.

(argparse/sys chỉ để đọc input dòng lệnh, không liên quan tới phần
LOGIC tính subnet - phần đó mới là thứ cố tình không dùng thư viện.)
------------------------------------------------------------------
"""

from __future__ import annotations
import sys


def ip_to_int(ip: str) -> int:
    """
    Chuyển "192.168.1.10" -> số nguyên 32-bit.
    1 IPv4 = 4 octet (mỗi octet 8 bit) ghép lại thành 1 số 32-bit,
    octet ĐẦU là 8 bit CAO NHẤT:
      192.168.1.10 -> 192*2^24 + 168*2^16 + 1*2^8 + 10*2^0
    """
    octets = ip.split(".")                 # tách chuỗi theo dấu "." -> ["192","168","1","10"]
    if len(octets) != 4:
        raise ValueError(f"IP không hợp lệ: {ip}")

    result = 0
    for octet in octets:
        value = int(octet)                  # chuyển từng phần string -> int
        if not 0 <= value <= 255:
            raise ValueError(f"Octet ngoài phạm vi 0-255: {octet}")
        result = (result << 8) | value       # dịch trái 8 bit (nhường chỗ cho octet mới) rồi OR octet vào 8 bit thấp
    return result


def int_to_ip(value: int) -> str:
    """Chiều ngược lại: số nguyên 32-bit -> chuỗi "a.b.c.d"."""
    octets = []
    for shift in (24, 16, 8, 0):            # lấy octet CAO NHẤT trước: dịch phải 24, rồi 16, rồi 8, rồi 0 bit
        octet = (value >> shift) & 0xFF      # dịch phải "shift" bit, AND với 11111111 để chỉ lấy đúng 8 bit thấp nhất
        octets.append(str(octet))
    return ".".join(octets)                  # nối lại 4 phần bằng dấu "."


def prefix_to_mask_int(prefix: int) -> int:
    """
    /24 -> subnet mask dạng số nguyên 32-bit, tức 24 bit đầu là 1,
    8 bit sau là 0: 11111111.11111111.11111111.00000000
    """
    if not 0 <= prefix <= 32:
        raise ValueError(f"Prefix phải trong khoảng 0-32, nhận {prefix}")
    if prefix == 0:
        return 0                              # /0 = không có bit mask nào là 1
    # 0xFFFFFFFF = 32 bit toàn số 1. Dịch phải (32-prefix) bit để đẩy
    # (32-prefix) bit thấp nhất "rơi ra ngoài" thành 0, kết quả còn
    # đúng "prefix" bit 1 ở đầu (vì Python int không giới hạn 32 bit,
    # AND với 0xFFFFFFFF để cắt về đúng 32 bit trước khi dùng tiếp).
    return (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF


def calculate_subnet(ip: str, prefix: int) -> dict:
    ip_int = ip_to_int(ip)
    mask_int = prefix_to_mask_int(prefix)

    network_int = ip_int & mask_int                      # network = IP AND mask -> xoá hết phần host-bit về 0
    wildcard_int = mask_int ^ 0xFFFFFFFF                  # wildcard mask = đảo ngược (XOR toàn 1) từng bit của subnet mask
    broadcast_int = network_int | wildcard_int            # broadcast = network OR wildcard -> bật hết phần host-bit lên 1

    total_hosts = 2 ** (32 - prefix)                      # tổng số địa chỉ trong subnet (gồm cả network/broadcast)

    if prefix >= 31:
        # /31 (point-to-point, RFC 3021) và /32 (1 host đơn) không có
        # khái niệm network/broadcast riêng theo nghĩa thông thường
        usable_hosts = total_hosts
        first_usable = int_to_ip(network_int)
        last_usable = int_to_ip(broadcast_int)
    else:
        usable_hosts = total_hosts - 2                    # trừ địa chỉ network và broadcast, không dùng để gán host
        first_usable = int_to_ip(network_int + 1)          # host đầu tiên = network + 1
        last_usable = int_to_ip(broadcast_int - 1)          # host cuối cùng = broadcast - 1

    return {
        "ip": ip,
        "prefix": prefix,
        "netmask": int_to_ip(mask_int),
        "wildcard_mask": int_to_ip(wildcard_int),
        "network": int_to_ip(network_int),
        "broadcast": int_to_ip(broadcast_int),
        "first_usable": first_usable,
        "last_usable": last_usable,
        "total_hosts": total_hosts,
        "usable_hosts": usable_hosts,
        "binary_mask": ".".join(                            # ghép 4 nhóm 8-bit bằng dấu "." cho giống định dạng IP
            format(mask_int, "032b")[i:i + 8] for i in range(0, 32, 8)
        ),
    }


def print_result(result: dict) -> None:
    print(f"IP đầu vào     : {result['ip']}/{result['prefix']}")
    print(f"Subnet mask    : {result['netmask']}  ({result['binary_mask']})")
    print(f"Wildcard mask  : {result['wildcard_mask']}")
    print(f"Network        : {result['network']}")
    print(f"Broadcast      : {result['broadcast']}")
    print(f"Host khả dụng  : {result['first_usable']} - {result['last_usable']}")
    print(f"Tổng địa chỉ   : {result['total_hosts']}")
    print(f"Host dùng được : {result['usable_hosts']}")


def parse_cidr(cidr: str) -> tuple[str, int]:
    """Tách "192.168.1.10/24" -> ("192.168.1.10", 24)."""
    if "/" not in cidr:
        raise ValueError("Cần định dạng IP/prefix, vd 192.168.1.0/24")
    ip_part, prefix_part = cidr.split("/", 1)               # split tối đa 1 lần tại dấu "/" đầu tiên
    return ip_part, int(prefix_part)


def main() -> None:
    if len(sys.argv) != 2:
        print("Dùng: python3 subnet_calculator.py <IP>/<prefix>")
        print("VD  : python3 subnet_calculator.py 192.168.1.130/26")
        sys.exit(1)

    ip, prefix = parse_cidr(sys.argv[1])
    result = calculate_subnet(ip, prefix)
    print_result(result)

    # TODO tự thử:
    #   1) Thêm hàm split_into_subnets(cidr, new_prefix) chia 1 subnet
    #      lớn thành nhiều subnet nhỏ hơn (vd chia 1 /24 thành 4 /26).
    #   2) Thêm hàm same_subnet(ip1, ip2, prefix) kiểm tra 2 IP có
    #      cùng nằm trong 1 subnet hay không (so sánh network).


if __name__ == "__main__":
    main()
