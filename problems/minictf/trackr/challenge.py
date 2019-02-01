from hacksport.problem import Challenge, File

class Problem(Challenge):

    def generate_flag(self, random):
        self.flag = "CTF{why_is_it_xss_but_not_xsrf}"
        return self.flag

    def setup(self):
        pass
    
