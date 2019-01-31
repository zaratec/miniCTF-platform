from hacksport.problem import Challenge, File

class Problem(Challenge):
    
    def generate_flag(self, random):
        self.flag = "CTF{orange_might_have_been_on_to_something_there}"
        return self.flag

    def setup(self):
        pass
    
