import Observation
import SwiftUI

struct CS: Identifiable, Hashable {
   let id = UUID()
   var csClassName: String?
   var isClass: Bool
   var professorName: String?
   var about: String
   var imageName: String?
   var image: Image? {
      if let imageName = imageName {
         return Image(imageName)
      } else {
         return nil
      }
   }
}

class ApplicationData {
   var userData: [CS] = []

   init() {
      userData = [
         CS(
            csClassName: "Intro to Comp Science: Python", isClass: true,
            professorName: "Jami Montgomery",
            about:
               "This course is intended for non-majors seeking an introduction to computer science and Python programming. The course covers the following topics: basic data types in Python, variables and constants, input and output, Python reserved words and built-in functions, operators, conditional control structures, repetition control structures, basic file operations, user-defined functions, value parameters, lists, scope rules, importing packages, elementary data processing and visualization, and elementary software engineering principles."
         ),
         CS(
            csClassName: "Computer Science I", isClass: true,
            professorName: "Nazli Goharian",
            about:
               "This course is intended for computer science majors and minors, and other students with a serious interest in learning C++ programming. The course covers the following topics: fundamental data types, the C++ string class, variables and constants, and their declaration, console input/output (cin/cout), assignment operators, arithmetic, relational, and Boolean operators, conditional control structures, repetition control structures, basic file operations, user-defined functions, value and reference parameters, scope rules, name precedence, function overloading, template functions, elementary software engineering principles, the Standard Template Library (STL), the vector class, elementary searching and sorting, user-defined classes, operator overloading, pointers, self-referential classes, dynamic object creation and destruction, linked lists, and recursion. COSC-1020 followed by COSC-1110 and COSC-1030 is the introductory sequence for the major and minor programs."
         ),
         CS(
            csClassName: "Computer Science II", isClass: true,
            professorName: "W. Woods",
            about:
               "COSC-1030 surveys advanced topics of C++ programming and introductory concepts of data structures. It is intended for computer science majors, minors, and other students with a serious interest in learning C++ programming. The course covers program design, organization, pointers, self-referential classes, dynamic object creation and destruction, linked lists, recursion, inheritance, virtual methods, polymorphism, template classes and functions, exception handling, C-style arrays, bit operations, elementary algorithm analysis, big-Oh notation, abstract data types, stacks, queues, deques, lists, vectors, sequences, priority queues, searching, and sorting. COSC 1020 followed by COSC 1110 and COSC 1030 is the introductory sequence for CS majors, CS minors, and other students with a strong interest in computer science."
         ),
         CS(
            csClassName: "Math Methods for Comp Sci", isClass: true,
            professorName: "Calvin Newport",
            about:
               "This course, designed to be taken concurrently with COSC-1030, covers mathematical tools and principles that are valuable to the computer scientist. Topics include: propositional and predicate logic; mathematical proofs, including induction; counting and basic probability theory; logarithmic and exponential functions; elementary graph theory; and Big-O notation and asymptotics."
         ),
         CS(
            csClassName: "Data Structures", isClass: true,
            professorName: "Bala Kalyanasundaram",
            about:
               "This course is designed as a second-year course for majors and minors. The main goals of the course are to present a variety of schemes for structuring data so that computer programs can efficiently insert, retrieve, modify, and remove information, to understand and express these operations as formal algorithms, and to analyze these algorithms formally. Using asymptotic analysis, the focus is on the analysis of worst-case running times of algorithms, although the course also covers the analysis of the average-case, amortized, and expected running times for selected algorithms. The data structures that the course surveys include unordered maps, hash tables, general trees, binary trees, ordered maps, search trees, self-balancing trees, multi-way trees, priority queues, heaps, sets, and graphs. Finally, the course reviews elementary sorting algorithms, presents heap-sort, and covers the formal analysis of their running times."
         ),
         CS(
            csClassName: "Advanced Programming", isClass: true,
            professorName: "Raymond Essick",
            about:
               "The objective of the course is to develop a mastery of object-oriented programming using the Java programming language and to expose students to advanced programming and basic software engineering concepts important for upper-division courses. Topics include, event-driven programming, graphical user interfaces (GUIs), human computer interaction, 2/3D Graphics, security, multimedia, exception handling, threads, sockets, networking, unit testing, mobile device programming, and the MapReduce programming model."
         ),
         CS(
            csClassName: "Handheld Device Programming", isClass: true,
            professorName: "Mahendran Velauthapillai",
            about:
               "This course covers Android/IOS programming. The major topics include: GUIs, layouts, menus, resource files, events, touch/gesture processing, accelerometer and motion event handling, images, video, audio, graphics, animation, maps, geo-location, threading, web services, timers, supporting various screen sizes/resolutions, and more. We will write Apps for Android phones/watches, iPhone, and Apple Watch."
         ),
         CS(
            isClass: false,
            professorName: "Mahendran Velauthapillai",
            about:
               "Mahe is one of the most amazing professors I've had at Georgetown. He's hilarious and his teaching style takes some adjusting, but he's so kind and he cares about his students on a level most professors don't. He wants to help you learn, not to waste your time. Take his class and talk to him",
            imageName: "mahe"
         ),
         CS(
            isClass: false,
            professorName: "Raymond Essick",
            about:
               "Graduate Program Manager",
            imageName: "ray"
         ),
         CS(
            isClass: false,
            professorName: "Bala Kalyanasundaram",
            about:
               "Craves Family Professor",
            imageName: "bala"
         ),
         CS(
            isClass: false,
            professorName: "Calvin Newport",
            about:
               "Director of Undergraduate Studies",
            imageName: "calvin"
         ),
         CS(
            isClass: false,
            professorName: "W. Woods",
            about:
               "Lieutenant Colonel, United States Army (Retired)",
            imageName: "woods"
         ),
         CS(
            isClass: false,
            professorName: "Nazli Goharian",
            about:
               "Associate Director of the Information Retrieval Lab",
            imageName: "nazli"
         ),
         CS(
            isClass: false,
            professorName: "Jami Montgomery",
            about:
               "Expert in Data Visualization, High Performance Computing",
            imageName: "jami"
         ),
      ]
   }
}
