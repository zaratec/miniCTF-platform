from hacksport.problem import Challenge, File

class Problem(Challenge):

    def generate_flag(self, random):
        self.flag = "CTF{creative-people-solve-crazy-security-problems"
        return self.flag

    def setup(self):
        pass
    
