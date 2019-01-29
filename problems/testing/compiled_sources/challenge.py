from hacksport.problem import Compiled, ProtectedFile


class Problem(Compiled):
    program_name = "simple_sources_binary"
    compiler_sources = ["mybinary.c"]
    files = [ProtectedFile("flag.txt")]
