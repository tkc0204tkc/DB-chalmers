import PortalConnection

def pause():
  input("Press Enter to continue...")
  print("")

if __name__ == "__main__":
    c = PortalConnection.PortalConnection()
    
    # Write your tests here. Add/remove calls to pause() as desired. 
    # print("Test 1:")
    # print(c.register("1111111111", "CCC111"))
    # print(c.getInfo("1111111111"))
    # pause()
    #
    # print("Test 2:")
    # print(c.register("5555555555", "CCC222"))
    # print(c.getInfo("5555555555"))
    # pause()
    #
    # print("Test 3:")
    # print(c.register("3333333333", "CCC222"))
    # print(c.getInfo("3333333333"))
    # pause()
    #
    # print("Test 4:")
    # print(c.register("5555555555", "CCC333"))
    # print(c.getInfo("5555555555"))
    # pause()
    #
    # print("Test 5:")
    # print(c.register("3333333333", "CCC333"))
    # print(c.getInfo("3333333333"))
    # pause()
    #
    # print("Test 6:")
    # print(c.register("4444444444", "CCC444"))
    # print(c.getInfo("4444444444"))
    # pause()
    #
    # print("Test 7:")
    # print(c.register("4444444444", "CCC111"))
    # print(c.getInfo("4444444444"))
    # pause()

    print("Test 1:")
    print(c.unregister("7777777777", "CCC333"))
    print(c.getInfo("2222222222"))
    pause()

    print("Test 2:")
    print(c.register("2222222222", "CCC333"));
    print(c.getInfo("2222222222"))
    pause()
    
    