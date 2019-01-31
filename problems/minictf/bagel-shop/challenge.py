from hacksport.problem import Challenge, File

class Problem(Challenge):
    files = [File("search.php")]
    
    def generate_flag(self, random):
        self.flag = "flag{h4ck_4nd_g3t_b4g3ls}"
        return self.flag

    def setup(self):
        pass
    
