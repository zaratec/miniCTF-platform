from hacksport.problem import Challenge, File

class Problem(Challenge):
    files = [File("index.php")]

    def generate_flag(self, random):
        self.flag = "CTF{y0u_br0ke_into_the_v4ult}"
        return self.flag

    def setup(self):
        pass
    
