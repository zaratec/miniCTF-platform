# picoCTF-web

The picoCTF-web component consists of the competitor facing web site, the API for running a CTF, as well as management functionality for CTF organizers.

## Quick Start
Though it is possible to use picoCTF-web as a stand alone component, it is best integrated with the rest of the [picoCTF-platform](https://github.com/picoCTF/picoCTF-platform). Please consult the Quick Start section of that repository for the simplest way to begin using this component.

## Features

The picoCTF-web component provides a number of core features that are common across jeopardy style CTFs such as:

- Problem List
    - Presents challenges (with optional hints)
    - Accepts flag submissions
    - Allows custom unlocking behavior where challenges can be "locked" and hidden until a competitor hits a certain threshold
- Scoreboard
    - Across a competition
    - Within a "Classroom" or sub organization
    - For individual progress within a challenge category

Also the picoCTF-web platform provides a number of features that are useful for running CTFs in an educational setting:

- Classrooms
    - Useful to manage multiple distinct groups of competitors as in a school setting. 
- Shell accounts
    - Integration with [picoCTF-shell](../picoCTF-shell) allows competitors full access to a linux account with the necessary tools all from a web browser
