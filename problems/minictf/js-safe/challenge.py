from hacksport.problem import Challenge, File

class Problem(Challenge):
    
    def generate_flag(self, random):
        self.flag = "CTF{i_<3_js}"
        return self.flag

    def setup(self):
        pass
    
