from hacksport.problem import Challenge, File

class Problem(Challenge):

    def generate_flag(self, random):
        self.flag = "CTF{more_length_extension_than_pinocchio}"
        return self.flag

    def setup(self):
        pass
    
