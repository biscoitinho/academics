#include <stdio.h>
#include <string.h>

struct Person {
  char name[50];
  int birthYear;
  float salary;
} person1;    //initialization of person1

int main() {
  //assign value to name person1
  strcpy(person1.name, "Joe Doe");

  //assign other values
  person1.birthYear = 1984;
  person1.salary = 20000;

  //print values
  printf("Name: %s\n", person1.name);
  printf("Birth Year: %d\n", person1.birthYear);

  return 0;
}
