const admin = require('firebase-admin');
const crypto = require('crypto');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const serviceAccount = require('./service-account.json');

admin.initializeApp({
  credential: admin.cert(serviceAccount),
  projectId: 'claritycrew-aa67a',
});

const db = getFirestore();
const Timestamp = FieldValue.serverTimestamp;

function toDocRef(collection, id) {
  return db.collection(collection).doc(id);
}

// ===== HELPER: generate a lesson object =====
function lesson(data) {
  return {
    id: data.id,
    title: data.title,
    description: data.description,
    unitId: data.unitId,
    subjectId: data.subjectId,
    courseId: data.courseId,
    overview: data.overview,
    notes: data.notes,
    revisionSummary: data.revisionSummary,
    resources: data.resources || [],
    quizIds: data.quizIds || [],
    exerciseIds: data.exerciseIds || [],
    prerequisiteLessonIds: data.prerequisiteLessonIds || [],
    estimatedMinutes: data.estimatedMinutes || 20,
    order: data.order || 1,
    difficulty: data.difficulty || 'beginner',
    language: 'en',
    isPublished: true,
  };
}

// ===== COURSES =====
const courses = [
  { id: 'cbse-class-6', title: 'CBSE Class 6', description: 'Complete CBSE curriculum for Class 6 covering Mathematics, Science, English, and Social Science.', category: 'cbse', difficulty: 'beginner', colorHex: '#6366F1', subjectIds: [], order: 1, language: 'en', isPublished: true, metadata: { board: 'CBSE', grade: 6, source: 'kolibri', sourceUrl: 'https://studio.learningequality.org/' } },
  { id: 'cbse-class-7', title: 'CBSE Class 7', description: 'Complete CBSE curriculum for Class 7 covering Mathematics, Science, English, and Social Science.', category: 'cbse', difficulty: 'easy', colorHex: '#8B5CF6', subjectIds: [], order: 2, language: 'en', isPublished: true, metadata: { board: 'CBSE', grade: 7, source: 'kolibri', sourceUrl: 'https://studio.learningequality.org/' } },
  { id: 'cbse-class-8', title: 'CBSE Class 8', description: 'Complete CBSE curriculum for Class 8 covering Mathematics, Science, English, and Social Science.', category: 'cbse', difficulty: 'medium', colorHex: '#A855F7', subjectIds: [], order: 3, language: 'en', isPublished: true, metadata: { board: 'CBSE', grade: 8, source: 'kolibri', sourceUrl: 'https://studio.learningequality.org/' } },
];

// ===== SUBJECTS =====
const subjects = [
  { id: 'c6-math', title: 'Mathematics', description: 'Class 6 Mathematics - Numbers, Geometry, Algebra, and Data Handling', courseId: 'cbse-class-6', colorHex: '#6366F1', unitIds: [], order: 1, language: 'en', isPublished: true },
  { id: 'c6-science', title: 'Science', description: 'Class 6 Science - Physics, Chemistry, and Biology fundamentals', courseId: 'cbse-class-6', colorHex: '#22C55E', unitIds: [], order: 2, language: 'en', isPublished: true },
  { id: 'c6-english', title: 'English', description: 'Class 6 English - Grammar, Reading Comprehension, and Writing Skills', courseId: 'cbse-class-6', colorHex: '#F59E0B', unitIds: [], order: 3, language: 'en', isPublished: true },
  { id: 'c6-social-science', title: 'Social Science', description: 'Class 6 Social Science - History, Geography, and Civics', courseId: 'cbse-class-6', colorHex: '#EF4444', unitIds: [], order: 4, language: 'en', isPublished: true },
  { id: 'c7-math', title: 'Mathematics', description: 'Class 7 Mathematics - Integers, Fractions, Algebra, Geometry, and Data Handling', courseId: 'cbse-class-7', colorHex: '#6366F1', unitIds: [], order: 1, language: 'en', isPublished: true },
  { id: 'c7-science', title: 'Science', description: 'Class 7 Science - Nutrition, Heat, Motion, Acids & Bases, and more', courseId: 'cbse-class-7', colorHex: '#22C55E', unitIds: [], order: 2, language: 'en', isPublished: true },
  { id: 'c8-math', title: 'Mathematics', description: 'Class 8 Mathematics - Rational Numbers, Linear Equations, Geometry, and Mensuration', courseId: 'cbse-class-8', colorHex: '#6366F1', unitIds: [], order: 1, language: 'en', isPublished: true },
  { id: 'c8-science', title: 'Science', description: 'Class 8 Science - Crop Production, Microorganisms, Force, Sound, and Light', courseId: 'cbse-class-8', colorHex: '#22C55E', unitIds: [], order: 2, language: 'en', isPublished: true },
];

// ===== UNITS =====
const units = [
  { id: 'c6-math-u1', title: 'Knowing Our Numbers', description: 'Learn about large numbers, place value, and comparing numbers.', subjectId: 'c6-math', courseId: 'cbse-class-6', lessonIds: [], order: 1, language: 'en', isPublished: true },
  { id: 'c6-math-u2', title: 'Whole Numbers', description: 'Understanding natural numbers, whole numbers, and their properties.', subjectId: 'c6-math', courseId: 'cbse-class-6', lessonIds: [], order: 2, language: 'en', isPublished: true },
  { id: 'c6-math-u3', title: 'Playing with Numbers', description: 'Factors, multiples, prime numbers, and divisibility rules.', subjectId: 'c6-math', courseId: 'cbse-class-6', lessonIds: [], order: 3, language: 'en', isPublished: true },
  { id: 'c6-math-u4', title: 'Basic Geometrical Ideas', description: 'Points, lines, angles, and basic shapes in geometry.', subjectId: 'c6-math', courseId: 'cbse-class-6', lessonIds: [], order: 4, language: 'en', isPublished: true },
  { id: 'c6-sci-u1', title: 'Food and Its Components', description: 'Understanding food sources, nutrients, and balanced diet.', subjectId: 'c6-science', courseId: 'cbse-class-6', lessonIds: [], order: 1, language: 'en', isPublished: true },
  { id: 'c6-sci-u2', title: 'Materials and Their Properties', description: 'Sorting materials, separation methods, and changes around us.', subjectId: 'c6-science', courseId: 'cbse-class-6', lessonIds: [], order: 2, language: 'en', isPublished: true },
  { id: 'c6-sci-u3', title: 'Motion, Light, and Electricity', description: 'Motion measurement, light shadows, and electric circuits.', subjectId: 'c6-science', courseId: 'cbse-class-6', lessonIds: [], order: 3, language: 'en', isPublished: true },
  { id: 'c6-eng-u1', title: 'Grammar Fundamentals', description: 'Nouns, pronouns, verbs, tenses, and sentence structure.', subjectId: 'c6-english', courseId: 'cbse-class-6', lessonIds: [], order: 1, language: 'en', isPublished: true },
  { id: 'c6-eng-u2', title: 'Reading and Writing', description: 'Reading comprehension, paragraph writing, and story writing.', subjectId: 'c6-english', courseId: 'cbse-class-6', lessonIds: [], order: 2, language: 'en', isPublished: true },
  { id: 'c6-sst-u1', title: 'History: Early Civilizations', description: 'What, Where, How and When? The beginning of human history.', subjectId: 'c6-social-science', courseId: 'cbse-class-6', lessonIds: [], order: 1, language: 'en', isPublished: true },
  { id: 'c6-sst-u2', title: 'Geography: The Earth', description: 'The Earth in the Solar System, Globe, and Maps.', subjectId: 'c6-social-science', courseId: 'cbse-class-6', lessonIds: [], order: 2, language: 'en', isPublished: true },
  { id: 'c7-math-u1', title: 'Integers and Fractions', description: 'Operations with integers, fractions, and decimals.', subjectId: 'c7-math', courseId: 'cbse-class-7', lessonIds: [], order: 1, language: 'en', isPublished: true },
  { id: 'c7-math-u2', title: 'Algebra and Geometry', description: 'Algebraic expressions, equations, and geometric constructions.', subjectId: 'c7-math', courseId: 'cbse-class-7', lessonIds: [], order: 2, language: 'en', isPublished: true },
  { id: 'c7-sci-u1', title: 'Nutrition and Heat', description: 'Nutrition in plants and animals, heat transfer, and temperature.', subjectId: 'c7-science', courseId: 'cbse-class-7', lessonIds: [], order: 1, language: 'en', isPublished: true },
  { id: 'c7-sci-u2', title: 'Motion and Chemistry', description: 'Motion, time, acids, bases, salts, and physical changes.', subjectId: 'c7-science', courseId: 'cbse-class-7', lessonIds: [], order: 2, language: 'en', isPublished: true },
  { id: 'c8-math-u1', title: 'Rational Numbers and Linear Equations', description: 'Properties of rational numbers and solving linear equations.', subjectId: 'c8-math', courseId: 'cbse-class-8', lessonIds: [], order: 1, language: 'en', isPublished: true },
  { id: 'c8-math-u2', title: 'Geometry and Mensuration', description: 'Quadrilaterals, polygons, area, and volume of shapes.', subjectId: 'c8-math', courseId: 'cbse-class-8', lessonIds: [], order: 2, language: 'en', isPublished: true },
  { id: 'c8-sci-u1', title: 'Crop Production and Microorganisms', description: 'Agricultural practices, microorganisms, and their uses.', subjectId: 'c8-science', courseId: 'cbse-class-8', lessonIds: [], order: 1, language: 'en', isPublished: true },
  { id: 'c8-sci-u2', title: 'Force, Sound, and Light', description: 'Force and pressure, sound waves, and light reflection.', subjectId: 'c8-science', courseId: 'cbse-class-8', lessonIds: [], order: 2, language: 'en', isPublished: true },
];

// ===== LESSONS (template literals for multi-line content) =====
const lessons = [];

lessons.push(lesson({
  id: 'c6-math-u1-l1', title: 'Large Numbers in Our Life',
  description: 'Understanding large numbers up to crore and their place values.',
  unitId: 'c6-math-u1', subjectId: 'c6-math', courseId: 'cbse-class-6', order: 1,
  difficulty: 'beginner', estimatedMinutes: 30,
  quizIds: ['quiz-c6-math-u1-l1'], exerciseIds: ['ex-c6-math-u1-l1'],
  overview: `In our daily lives, we often come across large numbers. The population of a country, the distance between planets, or the number of grains of sand on a beach are all examples of large numbers. In this lesson, we will learn how to read, write, and compare large numbers up to the crore (10 million) range.

### Key Concepts
- **Place value**: The value of a digit based on its position in a number
- **Indian number system**: Ones, Tens, Hundreds, Thousands, Ten Thousands, Lakhs, Ten Lakhs, Crores
- **International number system**: Ones, Tens, Hundreds, Thousands, Ten Thousands, Hundred Thousands, Millions
- **Comparing numbers**: Using >, <, and = symbols

### Example
The number 4,56,78,932 in the Indian system means 4 crore, 56 lakh, 78 thousand, 9 hundred, 3 tens, and 2 ones.`,
  notes: `# Large Numbers

## Indian Place Value System

| Period | Crores | Lakhs | Thousands | Ones |
|--------|--------|-------|-----------|------|
| Places | TC | C | TL | L | TTh | Th | H | T | O |

## Reading Large Numbers
- 1,00,000 = One Lakh
- 10,00,000 = Ten Lakhs (1 Million)
- 1,00,00,000 = One Crore (10 Million)

## Tips
- Use commas correctly: In Indian system, commas are placed after every two digits from the right except the first three
- Example: 5,23,45,678 = Five crore twenty-three lakh forty-five thousand six hundred seventy-eight

## Practice
Write the number: Forty-three lakh twenty-two thousand one hundred eleven = 43,22,111`,
  revisionSummary: `### Key Points
- Large numbers are used in population, distances, and money
- Indian place value: Ones, Tens, Hundreds, Thousands, Ten Thousands, Lakhs, Ten Lakhs, Crores
- Use commas to separate periods: 1,23,45,678
- To compare numbers: align by place value, compare from leftmost digit
- 1 Lakh = 100 Thousand, 1 Crore = 100 Lakhs`,
  resources: [
    { id: 'res-1', title: 'Place Value Chart PDF', type: 'document', url: '#', durationSeconds: 0, source: 'manual' },
    { id: 'res-2', title: 'Comparing Numbers Video', type: 'video', url: '#', durationSeconds: 420, source: 'manual' },
  ],
}));

lessons.push(lesson({
  id: 'c6-math-u1-l2', title: 'Comparing and Ordering Numbers',
  description: 'Learn to compare and arrange large numbers in ascending and descending order.',
  unitId: 'c6-math-u1', subjectId: 'c6-math', courseId: 'cbse-class-6', order: 2,
  difficulty: 'beginner', estimatedMinutes: 20,
  quizIds: ['quiz-c6-math-u1-l2'], exerciseIds: ['ex-c6-math-u1-l2'],
  prerequisiteLessonIds: ['c6-math-u1-l1'],
  overview: `Being able to compare and order numbers is an essential skill. Whether you are comparing prices while shopping or looking at population data, understanding which number is bigger or smaller matters.

### Rules for Comparing Numbers
1. Count the number of digits - the number with more digits is larger
2. If the count is the same, compare digits from the leftmost side
3. Continue comparing each digit until you find a difference

### Examples
- 45,678 vs 4,56,789: 4,56,789 has 6 digits, 45,678 has 5 digits -> 4,56,789 > 45,678
- 2,34,567 vs 2,43,567: Both have 6 digits. Compare: 2 = 2, then 3 < 4 -> 2,34,567 < 2,43,567`,
  notes: `# Comparing Numbers

## Step-by-Step Method
1. **Check digit count**: More digits = larger number
2. **Align by right**: Write numbers one below the other, right-aligned
3. **Compare left to right**: The first different digit decides

## Ascending Order
Smallest to largest: 12, 23, 34, 45, 56

## Descending Order
Largest to smallest: 56, 45, 34, 23, 12

## Real World Example
Population of cities:
- City A: 45,67,890
- City B: 45,76,890
- City C: 54,67,890
Ascending: A (45,67,890) < B (45,76,890) < C (54,67,890)`,
  revisionSummary: `### Key Points
- More digits -> larger number
- Same digits -> compare from leftmost
- Ascending = smallest to largest
- Descending = largest to smallest
- Use place value chart for tricky comparisons`,
}));

lessons.push(lesson({
  id: 'c6-math-u1-l3', title: 'Estimating and Rounding Numbers',
  description: 'Learn estimation techniques and rounding numbers to nearest tens, hundreds, and thousands.',
  unitId: 'c6-math-u1', subjectId: 'c6-math', courseId: 'cbse-class-6', order: 3,
  difficulty: 'easy', estimatedMinutes: 25,
  quizIds: ['quiz-c6-math-u1-l3'], exerciseIds: ['ex-c6-math-u1-l3'],
  prerequisiteLessonIds: ['c6-math-u1-l1'],
  overview: `Not every situation requires an exact number. Sometimes, a good estimate is enough! Estimation helps us make quick calculations and check if our exact answers are reasonable.

### Rounding Rules
- **To nearest 10**: Look at ones digit (0-4 round down, 5-9 round up)
- **To nearest 100**: Look at tens digit
- **To nearest 1000**: Look at hundreds digit

### Estimation in Real Life
- A crowd of 48,750 people ~= 50,000
- A movie ticket costing Rs 298 ~= Rs 300
- Shopping bill of Rs 1,247 ~= Rs 1,200`,
  notes: `# Estimation

## Rounding to Nearest 10
- 43 -> 40 (ones digit 3 < 5)
- 47 -> 50 (ones digit 7 >= 5)
- 45 -> 50 (ones digit 5, round up)

## Rounding to Nearest 100
- 123 -> 100 (tens digit 2 < 5)
- 178 -> 200 (tens digit 7 >= 5)

## Rounding to Nearest 1000
- 1,234 -> 1,000 (hundreds digit 2 < 5)
- 1,876 -> 2,000 (hundreds digit 8 >= 5)

## Estimating Sums
First round each number, then add.
Example: 1,234 + 1,876 ~= 1,000 + 2,000 = 3,000
Exact: 1,234 + 1,876 = 3,110 (close!)`,
  revisionSummary: `### Key Points
- Rounding replaces a number with a nearby simpler value
- Round up if the deciding digit is 5 or more, down if 4 or less
- Estimation helps verify exact calculations
- Always check which place value to round to`,
}));

lessons.push(lesson({
  id: 'c6-math-u2-l1', title: 'Natural Numbers and Whole Numbers',
  description: 'Understanding natural numbers, whole numbers, and the number line.',
  unitId: 'c6-math-u2', subjectId: 'c6-math', courseId: 'cbse-class-6', order: 1,
  difficulty: 'beginner', estimatedMinutes: 25,
  quizIds: ['quiz-c6-math-u2-l1'], exerciseIds: ['ex-c6-math-u2-l1'],
  prerequisiteLessonIds: ['c6-math-u1-l3'],
  overview: `### Natural Numbers
Natural numbers are the numbers we use for counting: 1, 2, 3, 4, 5, ...

### Whole Numbers
When we add 0 to the set of natural numbers, we get whole numbers: 0, 1, 2, 3, 4, 5, ...

### The Number Line
A number line is a straight line on which numbers are marked at equal intervals. It helps us visualize numbers and perform operations.

### Properties
- **Closure**: Sum of two whole numbers is always a whole number
- **Commutative**: a + b = b + a
- **Associative**: (a + b) + c = a + (b + c)
- **Additive Identity**: a + 0 = a`,
  notes: `# Whole Numbers

## Number Line

0---1---2---3---4---5---6---7---8---9---10

## Successor and Predecessor
- Successor = number + 1
- Predecessor = number - 1

Successor of 15 = 16
Predecessor of 15 = 14

## Properties Summary
| Property | Addition | Multiplication |
|----------|----------|---------------|
| Closed | Yes | Yes |
| Commutative | Yes | Yes |
| Associative | Yes | Yes |
| Identity | 0 | 1 |`,
  revisionSummary: `### Key Points
- Natural numbers: 1, 2, 3, 4, ... (counting numbers)
- Whole numbers: 0, 1, 2, 3, 4, ... (natural + zero)
- Number line helps visualize and compare numbers
- Whole numbers are closed under addition and multiplication
- 0 is the additive identity for whole numbers`,
}));

lessons.push(lesson({
  id: 'c6-math-u2-l2', title: 'Properties of Whole Numbers',
  description: 'Detailed study of closure, commutative, associative, and distributive properties.',
  unitId: 'c6-math-u2', subjectId: 'c6-math', courseId: 'cbse-class-6', order: 2,
  difficulty: 'easy', estimatedMinutes: 30,
  quizIds: ['quiz-c6-math-u2-l2'], exerciseIds: ['ex-c6-math-u2-l2'],
  prerequisiteLessonIds: ['c6-math-u2-l1'],
  overview: `Properties of whole numbers help us simplify calculations and understand the structure of mathematics.

### Closure Property
- Addition: 5 + 3 = 8 (whole number)
- Subtraction: 3 - 5 = -2 (not a whole number)
- Multiplication: 4 x 6 = 24 (whole number)
- Division: 7 / 2 = 3.5 (not a whole number)

### Commutative Property
- a + b = b + a (e.g., 5 + 3 = 3 + 5)
- a x b = b x a (e.g., 4 x 6 = 6 x 4)

### Associative Property
- (a + b) + c = a + (b + c)
- (a x b) x c = a x (b x c)

### Distributive Property
- a x (b + c) = a x b + a x c`,
  notes: `# Properties Reference

## Distributive Property Explained
6 x 35 = 6 x (30 + 5)
       = 6 x 30 + 6 x 5
       = 180 + 30
       = 210

## Using Properties for Mental Math
- 25 x 48 = 25 x (50 - 2) = 1250 - 50 = 1200
- 99 x 15 = (100 - 1) x 15 = 1500 - 15 = 1485

## Pattern to Remember
| Property | Addition | Multiplication |
|----------|----------|---------------|
| Closure | Yes | Yes |
| Commutative | Yes | Yes |
| Associative | Yes | Yes |
| Identity | 0 | 1 |
| Distributive | No | Yes over + |`,
  revisionSummary: `### Key Points
- Closure: Sum/product of whole numbers is always a whole number
- Commutative: Order does not matter for addition/multiplication
- Associative: Grouping does not matter for addition/multiplication
- Distributive: a x (b + c) = a x b + a x c
- Use properties to simplify mental calculations`,
}));

lessons.push(lesson({
  id: 'c6-math-u3-l1', title: 'Factors and Multiples',
  description: 'Understanding factors, multiples, prime numbers, and composite numbers.',
  unitId: 'c6-math-u3', subjectId: 'c6-math', courseId: 'cbse-class-6', order: 1,
  difficulty: 'easy', estimatedMinutes: 30,
  quizIds: ['quiz-c6-math-u3-l1'], exerciseIds: ['ex-c6-math-u3-l1'],
  prerequisiteLessonIds: ['c6-math-u2-l2'],
  overview: `### Factors
A factor of a number divides it exactly without leaving a remainder.
Example: Factors of 12 are 1, 2, 3, 4, 6, and 12.

### Multiples
A multiple of a number is obtained by multiplying it by a whole number.
Example: Multiples of 3 are 3, 6, 9, 12, 15, ...

### Prime Numbers
Numbers with exactly two factors: 1 and the number itself.
Examples: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29
Note: 2 is the only even prime number.

### Composite Numbers
Numbers with more than two factors.
Examples: 4 (factors: 1, 2, 4), 6 (factors: 1, 2, 3, 6)`,
  notes: `# Factors and Multiples

## Finding Factors
36 = 1 x 36
   = 2 x 18
   = 3 x 12
   = 4 x 9
   = 6 x 6
Factors: 1, 2, 3, 4, 6, 9, 12, 18, 36

## Sieve of Eratosthenes
A method to find all primes up to a given number.

## Twin Primes
Pairs of primes differing by 2: (3,5), (5,7), (11,13), (17,19)

## Co-prime Numbers
Numbers with HCF = 1: (4, 9), (8, 15)

## Perfect Numbers
Numbers where sum of factors (excluding itself) equals the number.
6 = 1 + 2 + 3 (perfect number!)`,
  revisionSummary: `### Key Points
- Factor: divides a number exactly
- Multiple: number x whole number
- Prime numbers: exactly 2 factors
- Composite numbers: more than 2 factors
- 1 is neither prime nor composite
- 2 is the only even prime number`,
}));

lessons.push(lesson({
  id: 'c6-math-u3-l2', title: 'Divisibility Rules',
  description: 'Learn quick rules to check if one number is divisible by another.',
  unitId: 'c6-math-u3', subjectId: 'c6-math', courseId: 'cbse-class-6', order: 2,
  difficulty: 'easy', estimatedMinutes: 25,
  quizIds: ['quiz-c6-math-u3-l2'], exerciseIds: ['ex-c6-math-u3-l2'],
  prerequisiteLessonIds: ['c6-math-u3-l1'],
  overview: `Divisibility rules are shortcuts to determine whether a number is divisible by another number without performing the full division.

### Divisibility Rules Table
| Divisible by | Check |
|-------------|-------|
| 2 | Last digit is 0, 2, 4, 6, or 8 |
| 3 | Sum of digits is divisible by 3 |
| 4 | Last two digits are divisible by 4 |
| 5 | Last digit is 0 or 5 |
| 6 | Divisible by both 2 and 3 |
| 8 | Last three digits divisible by 8 |
| 9 | Sum of digits is divisible by 9 |
| 10 | Last digit is 0 |
| 11 | Difference of sums of alternate digits is 0 or multiple of 11 |

### Example
Is 2,34,567 divisible by 3?
Sum = 2 + 3 + 4 + 5 + 6 + 7 = 27
27 is divisible by 3 -> Yes!

Is 2,34,567 divisible by 4?
Last two digits: 67
67 is not divisible by 4 -> No!`,
  notes: `# Divisibility Rules

## Rule for 11
Check 1,23,456:
Sum of odd positions: 1 + 3 + 5 = 9
Sum of even positions: 2 + 4 + 6 = 12
Difference: |9 - 12| = 3
3 is not 0 or multiple of 11 -> Not divisible

## Why These Rules Work
- Rule of 3: Since 10 = 9 + 1, 100 = 99 + 1, etc.
- Rule of 9: Similar to 3, because 9, 99, 999... are all multiples of 9

## Combined Rules
- Divisible by 12 = divisible by 3 and 4
- Divisible by 15 = divisible by 3 and 5
- Divisible by 18 = divisible by 2 and 9`,
  revisionSummary: `### Key Points
- 2: Even numbers
- 3: Sum of digits divisible by 3
- 4: Last 2 digits divisible by 4
- 5: Ends in 0 or 5
- 6: Divisible by 2 and 3
- 8: Last 3 digits divisible by 8
- 9: Sum of digits divisible by 9
- 10: Ends in 0
- 11: Difference of alternate digit sums is 0 or multiple of 11`,
}));

lessons.push(lesson({
  id: 'c6-math-u3-l3', title: 'HCF and LCM',
  description: 'Finding Highest Common Factor and Lowest Common Multiple.',
  unitId: 'c6-math-u3', subjectId: 'c6-math', courseId: 'cbse-class-6', order: 3,
  difficulty: 'medium', estimatedMinutes: 30,
  quizIds: ['quiz-c6-math-u3-l3'], exerciseIds: ['ex-c6-math-u3-l3'],
  prerequisiteLessonIds: ['c6-math-u3-l1', 'c6-math-u3-l2'],
  overview: `### HCF (Highest Common Factor)
The largest number that divides two or more numbers exactly.

### LCM (Lowest Common Multiple)
The smallest number that is a multiple of two or more numbers.

### Methods to Find HCF
1. **Prime Factorization**: List prime factors of each number, multiply common factors
2. **Division Method**: Divide larger by smaller, then divisor by remainder, repeat

### Methods to Find LCM
1. **Prime Factorization**: List prime factors, take highest power of each
2. **Common Division**: Divide by common factors, multiply all divisors and remaining numbers

### Relationship
HCF x LCM = Product of the two numbers
(For two numbers a and b: HCF(a,b) x LCM(a,b) = a x b)`,
  notes: `# HCF and LCM

## Example: HCF of 24 and 36
Prime factors:
24 = 2 x 2 x 2 x 3
36 = 2 x 2 x 3 x 3
Common = 2 x 2 x 3 = 12
HCF = 12

## Example: LCM of 24 and 36
24 = 2^3 x 3
36 = 2^2 x 3^2
LCM = 2^3 x 3^2 = 8 x 9 = 72

## Word Problem
Two bells ring at intervals of 12 and 18 minutes. When will they ring together again?
Answer: LCM(12, 18) = 36 minutes later`,
  revisionSummary: `### Key Points
- HCF: Greatest common factor (always <= each number)
- LCM: Smallest common multiple (always >= each number)
- For two numbers: HCF x LCM = Product
- HCF of co-prime numbers is always 1
- LCM of co-prime numbers is their product`,
}));

lessons.push(lesson({
  id: 'c6-math-u4-l1', title: 'Points, Lines, and Angles',
  description: 'Basic concepts of geometry - points, line segments, rays, lines, and angles.',
  unitId: 'c6-math-u4', subjectId: 'c6-math', courseId: 'cbse-class-6', order: 1,
  difficulty: 'beginner', estimatedMinutes: 25,
  quizIds: ['quiz-c6-math-u4-l1'], exerciseIds: ['ex-c6-math-u4-l1'],
  overview: `Geometry is the branch of mathematics that deals with points, lines, shapes, and space.

### Basic Terms
- **Point**: An exact location in space. Denoted by a dot and a capital letter.
- **Line Segment**: Part of a line with two endpoints.
- **Ray**: Part of a line with one endpoint.
- **Line**: Extends infinitely in both directions.
- **Angle**: Formed by two rays with a common endpoint (vertex).

### Types of Angles
| Angle Type | Measure |
|-----------|---------|
| Acute | Less than 90 degrees |
| Right | Exactly 90 degrees |
| Obtuse | Between 90 and 180 degrees |
| Straight | Exactly 180 degrees |
| Reflex | Between 180 and 360 degrees |
| Complete | Exactly 360 degrees |`,
  notes: `# Basic Geometry

## Naming Conventions
- Point: P
- Line Segment: AB
- Ray: AB (with arrow on top)
- Line: AB (with double arrow on top)

## Parallel Lines
Lines that never meet, no matter how far extended.

## Intersecting Lines
Lines that meet at a point.

## Perpendicular Lines
Lines that intersect at right angles (90 degrees).

## Angle Measurement
Use a protractor to measure angles in degrees.

## Curves
- Simple Curve: Does not cross itself
- Closed Curve: Starts and ends at the same point
- Open Curve: Has distinct start and end points`,
  revisionSummary: `### Key Points
- Point: exact location (no size)
- Line: extends infinitely (no endpoints)
- Line Segment: has two endpoints
- Ray: has one endpoint
- Acute < 90 < Obtuse < 180 < Reflex < 360
- Parallel lines never meet, perpendicular lines meet at 90 degrees`,
}));

lessons.push(lesson({
  id: 'c6-math-u4-l2', title: 'Triangles and Quadrilaterals',
  description: 'Properties and classification of triangles and quadrilaterals.',
  unitId: 'c6-math-u4', subjectId: 'c6-math', courseId: 'cbse-class-6', order: 2,
  difficulty: 'easy', estimatedMinutes: 25,
  quizIds: ['quiz-c6-math-u4-l2'], exerciseIds: ['ex-c6-math-u4-l2'],
  prerequisiteLessonIds: ['c6-math-u4-l1'],
  overview: `### Triangles
A triangle is a three-sided polygon with three angles.

**Classification by Sides:**
- Equilateral: All sides equal
- Isosceles: Two sides equal
- Scalene: No sides equal

**Classification by Angles:**
- Acute: All angles < 90 degrees
- Right: One angle = 90 degrees
- Obtuse: One angle > 90 degrees

### Quadrilaterals
A quadrilateral is a four-sided polygon.

| Type | Properties |
|------|-----------|
| Square | All sides equal, all angles 90 degrees |
| Rectangle | Opposite sides equal, all angles 90 degrees |
| Parallelogram | Opposite sides parallel and equal |
| Rhombus | All sides equal, opposite angles equal |
| Trapezium | One pair of parallel sides |`,
  notes: `# Triangles and Quadrilaterals

## Triangle Properties
- Sum of angles = 180 degrees
- Sum of any two sides > third side

## Quadrilateral Properties
- Sum of angles = 360 degrees

## Special Quadrilaterals

**Square**: All sides equal, all 90 degrees
**Rectangle**: Opposite sides equal and parallel, all 90 degrees
**Parallelogram**: Opposite sides parallel and equal
**Rhombus**: All sides equal, opposite sides parallel
**Trapezium**: Only one pair of parallel sides

## Circle Terms
- Center
- Radius
- Diameter (2 x radius)
- Chord
- Arc
- Circumference`,
  revisionSummary: `### Key Points
- Triangles are classified by sides (equilateral, isosceles, scalene) and angles (acute, right, obtuse)
- Sum of triangle angles = 180 degrees
- Quadrilaterals have 4 sides, sum of angles = 360 degrees
- Square, rectangle, parallelogram, rhombus, trapezium are types of quadrilaterals
- A circle has center, radius, diameter, chord, and arc`,
}));

// Science
lessons.push(lesson({
  id: 'c6-sci-u1-l1', title: 'Food Sources and Types',
  description: 'Where does our food come from? Plant sources, animal sources, and food variety.',
  unitId: 'c6-sci-u1', subjectId: 'c6-science', courseId: 'cbse-class-6', order: 1,
  difficulty: 'beginner', estimatedMinutes: 20,
  quizIds: ['quiz-c6-sci-u1-l1'], exerciseIds: ['ex-c6-sci-u1-l1'],
  overview: `### Where Does Food Come From?
All food comes from plants or animals. Some foods come from both!

**Plant Sources:**
- Grains: Rice, wheat, maize, barley
- Vegetables: Potato, tomato, spinach, carrot
- Fruits: Apple, mango, banana, orange
- Pulses: Beans, lentils, chickpeas
- Spices: Turmeric, cumin, pepper

**Animal Sources:**
- Meat: Chicken, fish, mutton
- Dairy: Milk, cheese, yogurt, butter
- Eggs: Hen eggs, duck eggs
- Honey: Made by bees from flower nectar

### Food Variety
Different regions have different food habits based on:
- Climate and geography
- Cultural traditions
- Available resources`,
  notes: `# Food Sources

## Plant Parts We Eat
| Plant Part | Examples |
|-----------|----------|
| Roots | Carrot, radish, beetroot |
| Stems | Potato, ginger, sugarcane |
| Leaves | Spinach, cabbage, lettuce |
| Flowers | Cauliflower, broccoli |
| Fruits | Apple, tomato, cucumber |
| Seeds | Rice, wheat, beans |

## Animal Products
- Milk -> cheese, butter, yogurt, ghee
- Eggs -> boiled, scrambled, in baking
- Meat -> protein source
- Fish -> rich in omega-3 fatty acids
- Honey -> natural sweetener`,
  revisionSummary: `### Key Points
- Food comes from plants and animals
- Different parts of plants are eaten: roots, stems, leaves, flowers, fruits, seeds
- Animal products include milk, eggs, meat, and honey
- Food variety depends on region, climate, and culture
- A balanced diet includes foods from many sources`,
}));

lessons.push(lesson({
  id: 'c6-sci-u1-l2', title: 'Components of Food',
  description: 'Nutrients in food - carbohydrates, proteins, fats, vitamins, and minerals.',
  unitId: 'c6-sci-u1', subjectId: 'c6-science', courseId: 'cbse-class-6', order: 2,
  difficulty: 'easy', estimatedMinutes: 30,
  quizIds: ['quiz-c6-sci-u1-l2'], exerciseIds: ['ex-c6-sci-u1-l2'],
  prerequisiteLessonIds: ['c6-sci-u1-l1'],
  overview: `### Nutrients
Food contains different components called nutrients that our body needs to function properly.

| Nutrient | Function | Sources |
|----------|----------|---------|
| Carbohydrates | Energy | Rice, wheat, bread, potato |
| Proteins | Growth and repair | Pulses, meat, eggs, milk |
| Fats | Energy storage, insulation | Butter, oil, ghee, nuts |
| Vitamins | Protection from diseases | Fruits, vegetables |
| Minerals | Various body functions | Milk, green vegetables, salt |
| Fibre | Digestion | Whole grains, fruits, vegetables |
| Water | Essential for all processes | Water, juices, fruits |

### Test for Nutrients
- **Starch test**: Add iodine solution to food - blue-black color means starch is present
- **Protein test**: Add copper sulfate and caustic soda - violet color means protein present
- **Fat test**: Rub food on paper - translucent spot means fat is present`,
  notes: `# Components of Food

## Balanced Diet
A diet that contains all nutrients in proper proportions.

## Deficiency Diseases
| Deficiency | Disease |
|-----------|---------|
| Vitamin A | Night blindness |
| Vitamin B1 | Beriberi |
| Vitamin C | Scurvy |
| Vitamin D | Rickets |
| Iron | Anemia |
| Iodine | Goiter |
| Calcium | Weak bones |

## Food Pyramid
Grains (most) -> Vegetables/Fruits -> Proteins -> Fats/Sugars (least)`,
  revisionSummary: `### Key Points
- Seven essential nutrients: carbs, proteins, fats, vitamins, minerals, fibre, water
- Carbohydrates provide energy, proteins help growth, fats store energy
- Vitamin/mineral deficiencies cause specific diseases
- Iodine tests for starch, copper sulfate tests for protein
- A balanced diet includes foods from all nutrient groups`,
}));

lessons.push(lesson({
  id: 'c6-sci-u2-l1', title: 'Sorting Materials into Groups',
  description: 'Classification of materials based on their properties.',
  unitId: 'c6-sci-u2', subjectId: 'c6-science', courseId: 'cbse-class-6', order: 1,
  difficulty: 'beginner', estimatedMinutes: 20,
  quizIds: ['quiz-c6-sci-u2-l1'], exerciseIds: ['ex-c6-sci-u2-l1'],
  overview: `### Why Sort Materials?
Sorting helps us organize and understand the world around us. Materials can be sorted based on various properties.

### Properties of Materials
1. **Appearance**: Shiny (metals) or dull (wood, paper)
2. **Hardness**: Hard (stone) or soft (cotton)
3. **Transparency**: Transparent (glass), translucent (wax paper), or opaque (wood)
4. **Soluble/Insoluble**: Whether it dissolves in water
5. **Float/Sink**: Whether it floats or sinks in water
6. **Magnetic/Non-magnetic**: Whether attracted to a magnet
7. **Conductivity**: Whether it conducts heat or electricity

### States of Matter
- **Solid**: Fixed shape and volume (stone, wood)
- **Liquid**: Fixed volume, no fixed shape (water, oil)
- **Gas**: No fixed shape or volume (air, oxygen)`,
  notes: `# Sorting Materials

## Transparency
| Type | Light Passes Through | Example |
|------|--------------------|---------|
| Transparent | Completely | Glass, water |
| Translucent | Partially | Frosted glass, butter paper |
| Opaque | Not at all | Wood, metal, cardboard |

## Float or Sink?
- Objects float if they are less dense than water
- Cork, plastic, oil float
- Stone, metal sink

## Fun Fact
A steel ship floats because its shape makes it less dense overall than water!`,
  revisionSummary: `### Key Points
- Materials can be sorted by: appearance, hardness, transparency, solubility, float/sink, magnetism, conductivity
- Transparent: light passes through completely
- Translucent: light partially passes through
- Opaque: light cannot pass through
- Some substances dissolve in water (soluble), others do not (insoluble)
- Magnetic materials (iron, nickel, cobalt) are attracted to magnets`,
}));

// English
lessons.push(lesson({
  id: 'c6-eng-u1-l1', title: 'Nouns and Pronouns',
  description: 'Types of nouns and their usage, pronouns and their antecedents.',
  unitId: 'c6-eng-u1', subjectId: 'c6-english', courseId: 'cbse-class-6', order: 1,
  difficulty: 'beginner', estimatedMinutes: 25,
  quizIds: ['quiz-c6-eng-u1-l1'], exerciseIds: ['ex-c6-eng-u1-l1'],
  overview: `### Nouns
A noun is the name of a person, place, thing, or idea.

**Types of Nouns:**
| Type | Description | Examples |
|------|-------------|----------|
| Proper | Specific name | India, Rahul, Monday |
| Common | General name | boy, city, day |
| Collective | Group name | team, flock, bunch |
| Abstract | Idea/quality | love, courage, freedom |
| Material | Substance | water, gold, wood |

### Pronouns
A pronoun is used in place of a noun.

| Type | Examples |
|------|----------|
| Personal | I, you, he, she, it, we, they |
| Possessive | my, your, his, her, its, our, their |
| Reflexive | myself, yourself, himself, herself |
| Demonstrative | this, that, these, those |
| Interrogative | who, whom, which, what |`,
  notes: `# Nouns and Pronouns

## Singular and Plural
| Singular | Plural |
|----------|--------|
| child | children |
| foot | feet |
| tooth | teeth |
| man | men |
| woman | women |
| mouse | mice |
| sheep | sheep |

## Gender
| Masculine | Feminine |
|-----------|----------|
| boy | girl |
| king | queen |
| actor | actress |
| lion | lioness |
| waiter | waitress |

## Pronoun-Antecedent Agreement
A pronoun must agree with its antecedent in number and gender.
- Rahul brought his book.
- The girls completed their homework.`,
  revisionSummary: `### Key Points
- Nouns name people, places, things, or ideas
- Proper nouns are specific (capitalized), common nouns are general
- Collective nouns name groups (flock, team, crowd)
- Abstract nouns name ideas/qualities (love, honesty)
- Pronouns replace nouns to avoid repetition
- Pronouns must agree with their antecedents in number and gender`,
}));

lessons.push(lesson({
  id: 'c6-eng-u1-l2', title: 'Verbs and Tenses',
  description: 'Action words, types of verbs, and the three main tenses.',
  unitId: 'c6-eng-u1', subjectId: 'c6-english', courseId: 'cbse-class-6', order: 2,
  difficulty: 'easy', estimatedMinutes: 30,
  quizIds: ['quiz-c6-eng-u1-l2'], exerciseIds: ['ex-c6-eng-u1-l2'],
  prerequisiteLessonIds: ['c6-eng-u1-l1'],
  overview: `### Verbs
A verb is an action word that tells what the subject does.

**Types:**
- **Action verbs**: run, jump, eat, write
- **Linking verbs**: is, am, are, was, were
- **Helping verbs**: have, has, had, do, does, did

### Tenses
| Tense | Example |
|-------|---------|
| Present | I write every day. |
| Past | I wrote yesterday. |
| Future | I will write tomorrow. |

### Present Tense Forms
- Simple Present: I write
- Present Continuous: I am writing
- Present Perfect: I have written

### Past Tense Forms
- Simple Past: I wrote
- Past Continuous: I was writing
- Past Perfect: I had written`,
  notes: `# Verbs and Tenses

## Subject-Verb Agreement
| Subject | Verb |
|---------|------|
| He/She/It | writes (add -s/-es) |
| I/We/You/They | write |

## Irregular Verbs
| Present | Past | Past Participle |
|---------|------|----------------|
| go | went | gone |
| eat | ate | eaten |
| drink | drank | drunk |
| sing | sang | sung |
| swim | swam | swum |
| write | wrote | written |

## Helping Verbs for Tenses
- Past: was/were + -ing
- Future: will/shall
- Perfect: have/has/had + past participle`,
  revisionSummary: `### Key Points
- Verbs express action or state of being
- Three main tenses: past, present, future
- Simple tenses: basic time reference
- Continuous tenses: ongoing actions
- Perfect tenses: completed actions
- Subject and verb must agree in number
- Regular verbs add -ed, irregular verbs change form`,
}));

// Social Science
lessons.push(lesson({
  id: 'c6-sst-u1-l1', title: 'What, Where, How and When?',
  description: 'Introduction to history and how we study the past.',
  unitId: 'c6-sst-u1', subjectId: 'c6-social-science', courseId: 'cbse-class-6', order: 1,
  difficulty: 'beginner', estimatedMinutes: 20,
  quizIds: ['quiz-c6-sst-u1-l1'], exerciseIds: ['ex-c6-sst-u1-l1'],
  overview: `### What is History?
History is the study of past events, especially in human affairs.

### How Do We Study History?
Historians study the past using **sources**:

| Source Type | Examples |
|------------|----------|
| Literary | Books, manuscripts, inscriptions |
| Archaeological | Tools, pottery, coins, monuments |
| Oral | Stories passed down through generations |

### Key Questions
- **What** happened?
- **Where** did it happen?
- **How** do we know?
- **When** did it happen?

### Timeline
- Prehistoric: Before writing was invented
- Ancient: Early civilizations to about 500 CE
- Medieval: About 500 CE to 1500 CE
- Modern: After 1500 CE

### The Indian Subcontinent
The Indian subcontinent includes India, Pakistan, Bangladesh, Nepal, Bhutan, Sri Lanka, and the Maldives.`,
  notes: `# Studying History

## Types of Sources
**Primary Sources**: Made during the time period being studied
- Coins, inscriptions, pottery
- Original documents, letters

**Secondary Sources**: Made later, based on primary sources
- History textbooks
- Documentaries

## Archaeological Excavation
Archaeologists dig up remains of ancient settlements to learn about the past.

## Important Dates in Early Indian History
- c. 7000 BCE: Mehrgarh settlement
- c. 3300 BCE: Indus Valley Civilization begins
- c. 1500 BCE: Vedic period begins`,
  revisionSummary: `### Key Points
- History studies past events using sources
- Literary sources: written texts, inscriptions
- Archaeological sources: artifacts, buildings, tools
- Primary sources are from the period, secondary sources are later interpretations
- The Indian subcontinent is a large region including multiple modern countries
- History is divided into prehistoric, ancient, medieval, and modern periods`,
}));

// Class 7 Math
lessons.push(lesson({
  id: 'c7-math-u1-l1', title: 'Integers: Addition and Subtraction',
  description: 'Understanding integers and performing addition and subtraction with negative numbers.',
  unitId: 'c7-math-u1', subjectId: 'c7-math', courseId: 'cbse-class-7', order: 1,
  difficulty: 'easy', estimatedMinutes: 30,
  quizIds: ['quiz-c7-math-u1-l1'], exerciseIds: ['ex-c7-math-u1-l1'],
  overview: `### What are Integers?
Integers are whole numbers that can be positive, negative, or zero.

... -3, -2, -1, 0, 1, 2, 3 ...

### Number Line Representation
-4  -3  -2  -1   0   1   2   3   4

### Addition Rules
| Sign | Action | Example |
|------|--------|---------|
| + + | Add, keep positive | 5 + 3 = 8 |
| + - | Subtract, keep sign of larger | 5 + (-3) = 2 |
| - - | Add, keep negative | -5 + (-3) = -8 |

### Subtraction Rules
Subtracting an integer is the same as adding its opposite:
a - b = a + (-b)

Example: 5 - (-3) = 5 + 3 = 8`,
  notes: `# Integers

## Properties
| Property | Addition |
|----------|----------|
| Closure | a + b is integer |
| Commutative | a + b = b + a |
| Associative | (a+b)+c = a+(b+c) |
| Identity | a + 0 = a |
| Additive Inverse | a + (-a) = 0 |

## Integer Operations
7 + (-2) = 5
-7 + 2 = -5
-7 + (-2) = -9

7 - (-2) = 7 + 2 = 9
-7 - 2 = -7 + (-2) = -9
-7 - (-2) = -7 + 2 = -5

## Real World Application
- Temperature: 5 C - 8 C = -3 C
- Bank balance: Rs 500 - Rs 700 = -Rs 200
- Elevation: Sea level = 0, above = +, below = -`,
  revisionSummary: `### Key Points
- Integers: ..., -3, -2, -1, 0, 1, 2, 3, ...
- Adding two positives -> positive
- Adding two negatives -> negative
- Adding positive + negative -> subtract, take sign of larger
- Subtraction = adding the opposite: a - b = a + (-b)
- Every integer has an additive inverse (a + (-a) = 0)`,
}));

// Class 8 Math
lessons.push(lesson({
  id: 'c8-math-u1-l1', title: 'Rational Numbers',
  description: 'Properties of rational numbers and operations on them.',
  unitId: 'c8-math-u1', subjectId: 'c8-math', courseId: 'cbse-class-8', order: 1,
  difficulty: 'medium', estimatedMinutes: 30,
  quizIds: ['quiz-c8-math-u1-l1'], exerciseIds: ['ex-c8-math-u1-l1'],
  overview: `### What are Rational Numbers?
Numbers that can be expressed as p/q where p and q are integers and q is not 0.

### Examples
- 2/3, -4/5, 7, -9, 0 (all integers are rational)
- 0.5 = 1/2, 0.75 = 3/4

### Properties
| Property | Description |
|----------|-------------|
| Closure | Sum/difference/product of rationals is rational |
| Commutative | a + b = b + a, a x b = b x a |
| Associative | (a+b)+c = a+(b+c), (a x b) x c = a x (b x c) |
| Distributive | a x (b + c) = a x b + a x c |
| Identity | 0 for addition, 1 for multiplication |
| Inverse | -a for addition, 1/a for multiplication (a not 0) |

### Representing on Number Line
To represent 3/4:
1. Draw a number line from 0 to 1
2. Divide into 4 equal parts
3. Count 3 parts from 0 -> that is 3/4`,
  notes: `# Rational Numbers

## Equivalent Rational Numbers
Multiply numerator and denominator by same number:
2/3 = 4/6 = 6/9 = 8/12

## Standard Form
Denominator is positive, numerator and denominator have no common factor other than 1.
2/3 is in standard form. 4/6 is not (HCF of 4 and 6 is 2).

## Comparison
Cross-multiply to compare:
Is 2/3 > 3/5?
2 x 5 = 10, 3 x 3 = 9
10 > 9, so 2/3 > 3/5

## Operations
2/3 + 1/2 = 4/6 + 3/6 = 7/6
2/3 - 1/2 = 4/6 - 3/6 = 1/6
2/3 x 1/2 = 2/6 = 1/3
2/3 / 1/2 = 2/3 x 2/1 = 4/3`,
  revisionSummary: `### Key Points
- Rational numbers = p/q form where q is not 0
- All integers and fractions are rational numbers
- Rational numbers are closed under +, -, x, / (except / by 0)
- Commutative and associative for + and x
- Distributive: a x (b + c) = a x b + a x c
- Between any two rational numbers, there are infinitely many rational numbers`,
}));

// ===== QUIZZES =====
const quizzes = [
  {
    id: 'quiz-c6-math-u1-l1', lessonId: 'c6-math-u1-l1',
    questions: [
      { id: 'q-c6-m1-l1-1', lessonId: 'c6-math-u1-l1', question: 'What is the place value of 7 in 4,56,78,932?', options: ['Seventy thousand', 'Seven lakh', 'Seventy lakh', 'Seven crore'], correctIndex: 1, explanation: 'In the Indian system, 7 is in the lakhs place: 4,56,78,932 -> 4 crore, 56 lakh, 78 thousand. The 7 is in the lakhs position.', difficulty: 'medium', type: 'multiple_choice', order: 1 },
      { id: 'q-c6-m1-l1-2', lessonId: 'c6-math-u1-l1', question: 'Which of the following has the most number of digits?', options: ['Ten thousand', 'One lakh', 'One crore', 'Ten crore'], correctIndex: 3, explanation: 'Ten crore = 10,00,00,000 (9 digits). One crore = 1,00,00,000 (8 digits). One lakh = 1,00,000 (6 digits). Ten thousand = 10,000 (5 digits).', difficulty: 'easy', type: 'multiple_choice', order: 2 },
      { id: 'q-c6-m1-l1-3', lessonId: 'c6-math-u1-l1', question: 'Write the number: Fifty-three lakh forty-two thousand one hundred eight.', options: ['53,42,018', '53,42,108', '5,34,21,008', '53,42,180'], correctIndex: 1, explanation: 'Fifty-three lakh = 53,00,000; forty-two thousand = 42,000; one hundred eight = 108. Combined: 53,00,000 + 42,000 + 108 = 53,42,108.', difficulty: 'medium', type: 'multiple_choice', order: 3 },
    ],
  },
  {
    id: 'quiz-c6-math-u1-l2', lessonId: 'c6-math-u1-l2',
    questions: [
      { id: 'q-c6-m1-l2-1', lessonId: 'c6-math-u1-l2', question: 'Which number is larger: 45,67,890 or 4,56,789?', options: ['45,67,890', '4,56,789', 'Both are equal', 'Cannot be determined'], correctIndex: 0, explanation: '45,67,890 has 7 digits, while 4,56,789 has 6 digits. The number with more digits is larger.', difficulty: 'beginner', type: 'multiple_choice', order: 1 },
      { id: 'q-c6-m1-l2-2', lessonId: 'c6-math-u1-l2', question: 'Arrange in ascending order: 23,456; 23,546; 23,465.', options: ['23,456; 23,465; 23,546', '23,546; 23,465; 23,456', '23,456; 23,546; 23,465', '23,465; 23,456; 23,546'], correctIndex: 0, explanation: 'Compare from left: 23 is same. Compare hundreds: 4, 4, 5. So ascending: 23,456 < 23,465 < 23,546.', difficulty: 'easy', type: 'multiple_choice', order: 2 },
    ],
  },
  {
    id: 'quiz-c6-math-u1-l3', lessonId: 'c6-math-u1-l3',
    questions: [
      { id: 'q-c6-m1-l3-1', lessonId: 'c6-math-u1-l3', question: 'Round 2,456 to the nearest thousand.', options: ['2,000', '2,500', '3,000', '2,400'], correctIndex: 0, explanation: 'To round to nearest thousand, look at the hundreds digit: 4 < 5, so round down to 2,000.', difficulty: 'easy', type: 'multiple_choice', order: 1 },
      { id: 'q-c6-m1-l3-2', lessonId: 'c6-math-u1-l3', question: 'Estimate 1,234 + 1,876 by rounding to nearest thousand first.', options: ['3,000', '4,000', '2,000', '3,100'], correctIndex: 0, explanation: '1,234 -> 1,000. 1,876 -> 2,000. Sum = 1,000 + 2,000 = 3,000.', difficulty: 'medium', type: 'multiple_choice', order: 2 },
    ],
  },
  {
    id: 'quiz-c6-math-u2-l1', lessonId: 'c6-math-u2-l1',
    questions: [
      { id: 'q-c6-m2-l1-1', lessonId: 'c6-math-u2-l1', question: 'Which is a natural number but NOT a whole number?', options: ['0', '1', '-1', 'There is no such number'], correctIndex: 3, explanation: 'Natural numbers = {1, 2, 3, ...}. Whole numbers = {0, 1, 2, 3, ...}. All natural numbers are whole numbers.', difficulty: 'medium', type: 'multiple_choice', order: 1 },
      { id: 'q-c6-m2-l1-2', lessonId: 'c6-math-u2-l1', question: 'What is the successor of 99,999?', options: ['99,998', '1,00,000', '99,99,999', '10,000'], correctIndex: 1, explanation: 'Successor = number + 1. 99,999 + 1 = 1,00,000.', difficulty: 'easy', type: 'multiple_choice', order: 2 },
    ],
  },
  {
    id: 'quiz-c6-math-u2-l2', lessonId: 'c6-math-u2-l2',
    questions: [
      { id: 'q-c6-m2-l2-1', lessonId: 'c6-math-u2-l2', question: 'Which property: 15 x (20 + 5) = (15 x 20) + (15 x 5)?', options: ['Commutative', 'Associative', 'Distributive', 'Closure'], correctIndex: 2, explanation: 'The distributive property: a x (b + c) = a x b + a x c.', difficulty: 'easy', type: 'multiple_choice', order: 1 },
      { id: 'q-c6-m2-l2-2', lessonId: 'c6-math-u2-l2', question: 'Which is NOT always true for whole numbers?', options: ['a + b is a whole number', 'a - b is a whole number', 'a x b is a whole number', 'a + 0 = a'], correctIndex: 1, explanation: 'Whole numbers are not closed under subtraction. 3 - 5 = -2, not a whole number.', difficulty: 'medium', type: 'multiple_choice', order: 2 },
    ],
  },
  {
    id: 'quiz-c6-math-u3-l1', lessonId: 'c6-math-u3-l1',
    questions: [
      { id: 'q-c6-m3-l1-1', lessonId: 'c6-math-u3-l1', question: 'Which is a prime number?', options: ['1', '2', '4', '9'], correctIndex: 1, explanation: '2 has exactly two factors: 1 and 2. 1 is neither prime nor composite.', difficulty: 'easy', type: 'multiple_choice', order: 1 },
      { id: 'q-c6-m3-l1-2', lessonId: 'c6-math-u3-l1', question: 'How many factors does 16 have?', options: ['3', '4', '5', '6'], correctIndex: 2, explanation: 'Factors of 16: 1, 2, 4, 8, 16. That is 5 factors.', difficulty: 'medium', type: 'multiple_choice', order: 2 },
    ],
  },
  {
    id: 'quiz-c6-math-u3-l2', lessonId: 'c6-math-u3-l2',
    questions: [
      { id: 'q-c6-m3-l2-1', lessonId: 'c6-math-u3-l2', question: 'Is 2,34,567 divisible by 3?', options: ['Yes', 'No', 'Cannot be determined', 'Only if even'], correctIndex: 0, explanation: 'Sum of digits = 2+3+4+5+6+7 = 27. 27 is divisible by 3. So yes.', difficulty: 'medium', type: 'multiple_choice', order: 1 },
    ],
  },
  {
    id: 'quiz-c6-math-u3-l3', lessonId: 'c6-math-u3-l3',
    questions: [
      { id: 'q-c6-m3-l3-1', lessonId: 'c6-math-u3-l3', question: 'What is the HCF of 12 and 18?', options: ['3', '6', '36', '9'], correctIndex: 1, explanation: 'Factors of 12: 1,2,3,4,6,12. Factors of 18: 1,2,3,6,9,18. Common: 1,2,3,6. Highest = 6.', difficulty: 'easy', type: 'multiple_choice', order: 1 },
      { id: 'q-c6-m3-l3-2', lessonId: 'c6-math-u3-l3', question: 'LCM of two numbers is 36 and product is 216. What is HCF?', options: ['6', '12', '18', '9'], correctIndex: 0, explanation: 'HCF x LCM = Product. HCF x 36 = 216. HCF = 216 / 36 = 6.', difficulty: 'hard', type: 'multiple_choice', order: 2 },
    ],
  },
  {
    id: 'quiz-c6-math-u4-l1', lessonId: 'c6-math-u4-l1',
    questions: [
      { id: 'q-c6-m4-l1-1', lessonId: 'c6-math-u4-l1', question: 'What type of angle measures 90 degrees?', options: ['Acute', 'Right', 'Obtuse', 'Straight'], correctIndex: 1, explanation: 'A right angle measures exactly 90 degrees.', difficulty: 'beginner', type: 'multiple_choice', order: 1 },
      { id: 'q-c6-m4-l1-2', lessonId: 'c6-math-u4-l1', question: 'Lines that never meet are called:', options: ['Intersecting', 'Perpendicular', 'Parallel', 'Curved'], correctIndex: 2, explanation: 'Parallel lines never meet, no matter how far extended.', difficulty: 'beginner', type: 'multiple_choice', order: 2 },
    ],
  },
  {
    id: 'quiz-c6-math-u4-l2', lessonId: 'c6-math-u4-l2',
    questions: [
      { id: 'q-c6-m4-l2-1', lessonId: 'c6-math-u4-l2', question: 'How many sides does a quadrilateral have?', options: ['3', '4', '5', '6'], correctIndex: 1, explanation: 'A quadrilateral is a polygon with 4 sides and 4 vertices.', difficulty: 'beginner', type: 'multiple_choice', order: 1 },
      { id: 'q-c6-m4-l2-2', lessonId: 'c6-math-u4-l2', question: 'Sum of angles in a triangle is:', options: ['90 degrees', '180 degrees', '270 degrees', '360 degrees'], correctIndex: 1, explanation: 'The sum of angles in any triangle is always 180 degrees.', difficulty: 'easy', type: 'multiple_choice', order: 2 },
    ],
  },
  {
    id: 'quiz-c6-sci-u1-l1', lessonId: 'c6-sci-u1-l1',
    questions: [
      { id: 'q-c6-s1-l1-1', lessonId: 'c6-sci-u1-l1', question: 'Which is an animal source of food?', options: ['Rice', 'Milk', 'Potato', 'Apple'], correctIndex: 1, explanation: 'Milk comes from animals (cows, buffaloes). Rice, potato, and apple are from plants.', difficulty: 'beginner', type: 'multiple_choice', order: 1 },
      { id: 'q-c6-s1-l1-2', lessonId: 'c6-sci-u1-l1', question: 'Which plant part is a carrot?', options: ['Stem', 'Root', 'Leaf', 'Fruit'], correctIndex: 1, explanation: 'A carrot is the root of the carrot plant.', difficulty: 'easy', type: 'multiple_choice', order: 2 },
    ],
  },
  {
    id: 'quiz-c6-sci-u1-l2', lessonId: 'c6-sci-u1-l2',
    questions: [
      { id: 'q-c6-s1-l2-1', lessonId: 'c6-sci-u1-l2', question: 'Which nutrient provides the most energy?', options: ['Vitamins', 'Carbohydrates', 'Proteins', 'Minerals'], correctIndex: 1, explanation: 'Carbohydrates are the body\'s main source of energy.', difficulty: 'easy', type: 'multiple_choice', order: 1 },
      { id: 'q-c6-s1-l2-2', lessonId: 'c6-sci-u1-l2', question: 'Which vitamin deficiency causes night blindness?', options: ['Vitamin A', 'Vitamin B', 'Vitamin C', 'Vitamin D'], correctIndex: 0, explanation: 'Vitamin A deficiency causes night blindness. Sources: carrots, papaya, milk.', difficulty: 'medium', type: 'multiple_choice', order: 2 },
    ],
  },
  {
    id: 'quiz-c6-sci-u2-l1', lessonId: 'c6-sci-u2-l1',
    questions: [
      { id: 'q-c6-s2-l1-1', lessonId: 'c6-sci-u2-l1', question: 'Which is transparent?', options: ['Wood', 'Glass', 'Cardboard', 'Iron sheet'], correctIndex: 1, explanation: 'Glass is transparent - light passes through completely.', difficulty: 'beginner', type: 'multiple_choice', order: 1 },
      { id: 'q-c6-s2-l1-2', lessonId: 'c6-sci-u2-l1', question: 'Which floats on water?', options: ['Stone', 'Iron nail', 'Cork', 'Coin'], correctIndex: 2, explanation: 'Cork is less dense than water, so it floats.', difficulty: 'easy', type: 'multiple_choice', order: 2 },
    ],
  },
  {
    id: 'quiz-c6-eng-u1-l1', lessonId: 'c6-eng-u1-l1',
    questions: [
      { id: 'q-c6-e1-l1-1', lessonId: 'c6-eng-u1-l1', question: 'Which is a proper noun?', options: ['city', 'India', 'river', 'mountain'], correctIndex: 1, explanation: 'India is a proper noun - specific name of a country.', difficulty: 'beginner', type: 'multiple_choice', order: 1 },
      { id: 'q-c6-e1-l1-2', lessonId: 'c6-eng-u1-l1', question: 'What type of noun is "team"?', options: ['Common', 'Proper', 'Collective', 'Abstract'], correctIndex: 2, explanation: 'Team is a collective noun - it refers to a group of people.', difficulty: 'easy', type: 'multiple_choice', order: 2 },
    ],
  },
  {
    id: 'quiz-c6-eng-u1-l2', lessonId: 'c6-eng-u1-l2',
    questions: [
      { id: 'q-c6-e1-l2-1', lessonId: 'c6-eng-u1-l2', question: 'Which is in the past tense?', options: ['I eat breakfast.', 'I am eating breakfast.', 'I ate breakfast.', 'I will eat breakfast.'], correctIndex: 2, explanation: '"I ate" is the simple past tense of "eat".', difficulty: 'easy', type: 'multiple_choice', order: 1 },
      { id: 'q-c6-e1-l2-2', lessonId: 'c6-eng-u1-l2', question: 'Past tense of "go"?', options: ['goed', 'gone', 'went', 'going'], correctIndex: 2, explanation: '"Go" is irregular. Past tense is "went".', difficulty: 'medium', type: 'multiple_choice', order: 2 },
    ],
  },
  {
    id: 'quiz-c6-sst-u1-l1', lessonId: 'c6-sst-u1-l1',
    questions: [
      { id: 'q-c6-ss1-l1-1', lessonId: 'c6-sst-u1-l1', question: 'Which is an archaeological source?', options: ['Textbook', 'Ancient coin', 'Novel', 'Newspaper'], correctIndex: 1, explanation: 'Ancient coins are archaeological sources - physical objects from the past.', difficulty: 'easy', type: 'multiple_choice', order: 1 },
      { id: 'q-c6-ss1-l1-2', lessonId: 'c6-sst-u1-l1', question: 'The period before writing is called:', options: ['Ancient', 'Medieval', 'Modern', 'Prehistoric'], correctIndex: 3, explanation: 'Prehistoric is before writing was invented.', difficulty: 'medium', type: 'multiple_choice', order: 2 },
    ],
  },
  {
    id: 'quiz-c7-math-u1-l1', lessonId: 'c7-math-u1-l1',
    questions: [
      { id: 'q-c7-m1-l1-1', lessonId: 'c7-math-u1-l1', question: 'What is 5 + (-8)?', options: ['13', '-13', '3', '-3'], correctIndex: 3, explanation: '5 + (-8) = 5 - 8 = -3.', difficulty: 'easy', type: 'multiple_choice', order: 1 },
      { id: 'q-c7-m1-l1-2', lessonId: 'c7-math-u1-l1', question: 'What is -7 - (-3)?', options: ['-10', '-4', '4', '10'], correctIndex: 1, explanation: '-7 - (-3) = -7 + 3 = -4.', difficulty: 'medium', type: 'multiple_choice', order: 2 },
    ],
  },
  {
    id: 'quiz-c8-math-u1-l1', lessonId: 'c8-math-u1-l1',
    questions: [
      { id: 'q-c8-m1-l1-1', lessonId: 'c8-math-u1-l1', question: 'Which is a rational number?', options: ['pi', 'sqrt(2)', '3/4', 'All of these'], correctIndex: 2, explanation: '3/4 is a rational number (p/q form). pi and sqrt(2) are irrational.', difficulty: 'medium', type: 'multiple_choice', order: 1 },
      { id: 'q-c8-m1-l1-2', lessonId: 'c8-math-u1-l1', question: 'The additive inverse of -5/7 is:', options: ['5/7', '-5/7', '7/5', '-7/5'], correctIndex: 0, explanation: '(-5/7) + (5/7) = 0. So the additive inverse is 5/7.', difficulty: 'medium', type: 'multiple_choice', order: 2 },
    ],
  },
];

// ===== EXERCISES =====
const exercises = [
  { id: 'ex-c6-math-u1-l1', lessonId: 'c6-math-u1-l1', title: 'Writing Large Numbers', description: 'Practice writing large numbers in words and digits.', instructions: `Write the following numbers in words using the Indian number system:
1. 45,67,890
2. 1,23,45,678
3. 9,87,65,432
Then write these in digits:
4. Thirty-four lakh fifty-six thousand seven hundred eighty-nine
5. Seven crore eight lakh nine thousand four hundred fifty-six`, solution: `1. Forty-five lakh sixty-seven thousand eight hundred ninety
2. One crore twenty-three lakh forty-five thousand six hundred seventy-eight
3. Nine crore eighty-seven lakh sixty-five thousand four hundred thirty-two
4. 34,56,789
5. 7,08,09,456`, type: 'practice', difficulty: 'easy', hints: ['Use commas to separate periods', 'Remember: 1 crore = 100 lakhs'], order: 1, isPublished: true },
  { id: 'ex-c6-math-u1-l2', lessonId: 'c6-math-u1-l2', title: 'Comparing Numbers', description: 'Practice comparing and ordering large numbers.', instructions: `Compare using >, <, or =:
1. 45,67,890 ___ 4,56,789
2. 12,34,567 ___ 12,43,567
3. 99,99,999 ___ 1,00,00,000
Arrange in ascending order:
4. 23,45,678; 32,54,876; 23,54,876; 32,45,678`, solution: `1. 45,67,890 > 4,56,789 (more digits)
2. 12,34,567 < 12,43,567 (3 lakh < 4 lakh)
3. 99,99,999 < 1,00,00,000 (8 digits < 9 digits)
4. 23,45,678 < 23,54,876 < 32,45,678 < 32,54,876`, type: 'practice', difficulty: 'easy', hints: ['Compare the number of digits first', 'If same digits, compare from leftmost'], order: 1, isPublished: true },
  { id: 'ex-c6-math-u1-l3', lessonId: 'c6-math-u1-l3', title: 'Rounding Practice', description: 'Practice rounding numbers to different place values.', instructions: `Round each number:
1. 4,567 to nearest ten
2. 4,567 to nearest hundred
3. 4,567 to nearest thousand
4. 5,67,890 to nearest lakh
5. 23,45,678 to nearest ten lakh
6. Estimate: 1,234 + 5,678 (round to nearest thousand)`, solution: `1. 4,570
2. 4,600
3. 5,000
4. 6,00,000
5. 23,00,000
6. 1,000 + 6,000 = 7,000`, type: 'practice', difficulty: 'medium', hints: ['Identify the digit you are rounding to', 'Look at the digit to its right: 0-4 down, 5-9 up'], order: 1, isPublished: true },
  { id: 'ex-c6-math-u2-l1', lessonId: 'c6-math-u2-l1', title: 'Working with Whole Numbers', description: 'Practice with natural numbers, whole numbers, and the number line.', instructions: `1. Write the first 10 natural numbers.
2. Write the first 10 whole numbers.
3. Find the successor of 2,345.
4. Find the predecessor of 5,000.
5. Which is greater: predecessor of 100 or successor of 98?`, solution: `1. 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
2. 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
3. 2,346
4. 4,999
5. Predecessor of 100 = 99. Successor of 98 = 99. They are equal!`, type: 'practice', difficulty: 'beginner', hints: ['Successor = number + 1', 'Predecessor = number - 1'], order: 1, isPublished: true },
  { id: 'ex-c6-math-u2-l2', lessonId: 'c6-math-u2-l2', title: 'Properties in Action', description: 'Apply properties of whole numbers to simplify calculations.', instructions: `Use properties to solve mentally:
1. 25 x 48
2. 99 x 15
3. 125 x 32
4. 102 x 65
5. Which property: (5 + 3) + 7 = 5 + (3 + 7)?
6. True/False: Whole numbers are closed under subtraction.`, solution: `1. 25 x (50 - 2) = 1,250 - 50 = 1,200
2. (100 - 1) x 15 = 1,500 - 15 = 1,485
3. 125 x 8 x 4 = 1,000 x 4 = 4,000
4. (100 + 2) x 65 = 6,500 + 130 = 6,630
5. Associative property of addition
6. False (3 - 5 = -2, not a whole number)`, type: 'practice', difficulty: 'medium', hints: ['Use distributive: a x (b + c) = a x b + a x c', 'Break into parts easy to multiply'], order: 1, isPublished: true },
  { id: 'ex-c6-math-u3-l1', lessonId: 'c6-math-u3-l1', title: 'Finding Factors and Primes', description: 'Practice finding factors and identifying prime numbers.', instructions: `1. List all factors of 24.
2. List all factors of 36.
3. What are common factors of 24 and 36?
4. Which are prime: 13, 21, 29, 33, 47, 51?
5. Write all prime numbers between 1 and 50.`, solution: `1. 1, 2, 3, 4, 6, 8, 12, 24
2. 1, 2, 3, 4, 6, 9, 12, 18, 36
3. 1, 2, 3, 4, 6, 12
4. Prime: 13, 29, 47 (21=3x7, 33=3x11, 51=3x17)
5. 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47`, type: 'practice', difficulty: 'easy', hints: ['A prime has exactly 2 factors: 1 and itself', 'Try dividing by small primes'], order: 1, isPublished: true },
  { id: 'ex-c6-math-u3-l2', lessonId: 'c6-math-u3-l2', title: 'Applying Divisibility Rules', description: 'Use divisibility rules to solve problems.', instructions: `Using divisibility rules:
1. Is 4,56,789 divisible by 2? By 3? By 5? By 9?
2. Is 12,34,560 divisible by 4? By 6? By 8? By 10?
3. Find smallest number divisible by both 3 and 4.`, solution: `1. By 2: No (ends in 9). By 3: 4+5+6+7+8+9=39, Yes. By 5: No. By 9: 39/9=4.33, No.
2. By 4: 60/4=15, Yes. By 6: Yes (even and sum=21 divisible by 3). By 8: 560/8=70, Yes. By 10: Yes.
3. Divisible by 3 and 4 = divisible by 12. Smallest = 12.`, type: 'practice', difficulty: 'medium', hints: ['For 6: divisible by both 2 and 3', 'For 4: check last 2 digits'], order: 1, isPublished: true },
  { id: 'ex-c6-math-u3-l3', lessonId: 'c6-math-u3-l3', title: 'HCF and LCM Problems', description: 'Find HCF and LCM and solve word problems.', instructions: `Find HCF and LCM of:
1. 12 and 18
2. 24 and 36
Word Problems:
3. Two bells ring every 12 and 15 minutes. When will they ring together?
4. Largest tape to measure 12 m, 18 m, and 24 m exactly?`, solution: `1. HCF=6, LCM=36
2. HCF=12, LCM=72
3. LCM(12, 15) = 60 minutes
4. HCF(12, 18, 24) = 6 meters`, type: 'practice', difficulty: 'medium', hints: ['HCF for dividing into equal groups', 'LCM for events that repeat'], order: 1, isPublished: true },
  { id: 'ex-c6-math-u4-l1', lessonId: 'c6-math-u4-l1', title: 'Identify the Shapes', description: 'Practice identifying points, lines, and angles.', instructions: `1. Draw and label a point P, a line segment AB.
2. Classify: 45 degrees, 90 degrees, 120 degrees, 180 degrees
3. What is the complement of 35 degrees? (sum = 90)`, solution: `1. [See drawings]
2. 45 = Acute, 90 = Right, 120 = Obtuse, 180 = Straight
3. 90 - 35 = 55 degrees`, type: 'practice', difficulty: 'easy', hints: ['Acute < 90', 'Obtuse > 90 and < 180'], order: 1, isPublished: true },
  { id: 'ex-c6-math-u4-l2', lessonId: 'c6-math-u4-l2', title: 'Triangle and Quadrilateral Types', description: 'Classify triangles and quadrilaterals.', instructions: `1. Classify triangle with sides 5 cm, 5 cm, 5 cm.
2. Classify triangle with angles 90, 45, 45 degrees.
3. How is a square different from a rhombus?
4. A triangle has angles 60, 70, 50. Is it acute or obtuse?`, solution: `1. Equilateral triangle
2. Right-angled isosceles triangle
3. Square: all angles 90; Rhombus: angles can differ
4. Acute (all angles < 90)`, type: 'practice', difficulty: 'medium', hints: ['All angles < 90 = acute', 'One angle > 90 = obtuse'], order: 1, isPublished: true },
  { id: 'ex-c6-sci-u1-l1', lessonId: 'c6-sci-u1-l1', title: 'Food Sources', description: 'Categorize foods by their sources.', instructions: `Categorize as plant or animal source:
1. Rice  2. Egg  3. Apple  4. Milk  5. Potato  6. Fish  7. Honey  8. Spinach  9. Cheese  10. Bread`, solution: `Plant: Rice, Apple, Potato, Spinach, Bread
Animal: Egg, Milk, Fish, Honey, Cheese`, type: 'practice', difficulty: 'beginner', hints: ['Think about where each food comes from originally'], order: 1, isPublished: true },
  { id: 'ex-c6-sci-u1-l2', lessonId: 'c6-sci-u1-l2', title: 'Nutrient Identification', description: 'Identify nutrients in different foods.', instructions: `1. Match: a) Carbohydrate - (i) Growth, b) Protein - (ii) Energy, c) Vitamin C - (iii) Strong bones, d) Calcium - (iv) Scurvy protection
2. Plan a balanced one-day meal menu.
3. What deficiency from lack of iron?`, solution: `1. a-ii, b-i, c-iv, d-iii
2. [Sample: Breakfast - oats+milk+fruits; Lunch - rice+dal+salad; Dinner - roti+paneer+veggies]
3. Iron deficiency causes anemia (weakness, tiredness, pale skin)`, type: 'practice', difficulty: 'medium', hints: ['Carbohydrates give energy like fuel', 'Proteins build and repair body'], order: 1, isPublished: true },
  { id: 'ex-c6-sci-u2-l1', lessonId: 'c6-sci-u2-l1', title: 'Sorting Materials', description: 'Classify materials based on properties.', instructions: `Classify as transparent/translucent/opaque:
1. Window glass 2. Wooden door 3. Butter paper 4. Clean water 5. Cardboard
6. Which dissolve in water? Salt, Sand, Sugar, Chalk powder, Oil
7. Which float? Steel spoon, Plastic bottle, Cork, Coin, Ice cube`, solution: `1. Transparent 2. Opaque 3. Translucent 4. Transparent 5. Opaque
6. Dissolve: Salt, Sugar. Not: Sand, Chalk powder, Oil
7. Float: Plastic bottle (empty), Cork, Ice cube`, type: 'practice', difficulty: 'easy', hints: ['Transparent = can see through clearly', 'Objects less dense than water float'], order: 1, isPublished: true },
  { id: 'ex-c6-eng-u1-l1', lessonId: 'c6-eng-u1-l1', title: 'Noun and Pronoun Practice', description: 'Practice identifying and using nouns and pronouns.', instructions: `Identify the noun type:
1. honesty  2. India  3. team  4. river  5. bravery
Replace with pronouns:
6. Rahul went to the market. -> ____ went.
7. The book is on the table. -> ____ is on the table.
8. Sita and Ram are playing. -> ____ are playing.`, solution: `1. Abstract 2. Proper 3. Collective 4. Common 5. Abstract
6. He 7. It 8. They`, type: 'practice', difficulty: 'easy', hints: ['Proper nouns are specific names with capital letters', 'Abstract nouns name ideas/qualities'], order: 1, isPublished: true },
  { id: 'ex-c6-eng-u1-l2', lessonId: 'c6-eng-u1-l2', title: 'Tense Transformation', description: 'Practice changing verbs between different tenses.', instructions: `Rewrite in the tense indicated:
1. She writes a letter. (Simple Past)
2. They play football. (Present Continuous)
3. He ate an apple. (Simple Present)
4. Fill blanks: She ___ (go) to school every day.`, solution: `1. She wrote a letter.
2. They are playing football.
3. He eats an apple.
4. goes`, type: 'practice', difficulty: 'medium', hints: ['Past: add -ed for regular verbs', 'Present Cont: am/is/are + verb-ing'], order: 1, isPublished: true },
  { id: 'ex-c6-sst-u1-l1', lessonId: 'c6-sst-u1-l1', title: 'Sources of History', description: 'Identify and categorize historical sources.', instructions: `Categorize as primary or secondary source:
1. Textbook on ancient India
2. Ashokan pillar inscription
3. Documentary about Harappan civilization
4. Ancient coins from Gupta period
5. Why are archaeological sources more reliable for very ancient periods?`, solution: `1. Secondary 2. Primary 3. Secondary 4. Primary
5. Archaeological sources are contemporary (from the time) and not subject to later changes.`, type: 'practice', difficulty: 'medium', hints: ['Primary = from the time period', 'Secondary = interpretations made later'], order: 1, isPublished: true },
  { id: 'ex-c7-math-u1-l1', lessonId: 'c7-math-u1-l1', title: 'Integer Operations', description: 'Practice addition and subtraction with integers.', instructions: `Solve:
1. 8 + (-5)
2. -12 + 7
3. -15 + (-8)
4. 9 - (-4)
5. -6 - 10
6. -8 - (-3)
7. Temperature 5 C drops by 12 C. New temperature?
8. Submarine at 200 m below sea moves 50 m up. New position?`, solution: `1. 3  2. -5  3. -23  4. 13  5. -16  6. -5
7. 5 - 12 = -7 C
8. -200 + 50 = -150 m (150 m below sea level)`, type: 'practice', difficulty: 'easy', hints: ['Adding negative = subtracting', 'Subtracting negative = adding positive'], order: 1, isPublished: true },
  { id: 'ex-c8-math-u1-l1', lessonId: 'c8-math-u1-l1', title: 'Rational Numbers Practice', description: 'Practice operations and properties of rational numbers.', instructions: `1. Write 3 rational numbers equivalent to 2/5.
2. Sum: 2/3 + 3/4
3. Product: (-2/5) x (3/7)
4. Divide: (3/4) / (-9/16)
5. Compare: 5/8 and 3/5
6. Find a rational number between 1/3 and 1/2`, solution: `1. 4/10, 6/15, 8/20
2. 8/12 + 9/12 = 17/12
3. -6/35
4. 3/4 x -16/9 = -48/36 = -4/3
5. 5/8 = 25/40, 3/5 = 24/40 => 5/8 > 3/5
6. (1/3 + 1/2)/2 = (5/6)/2 = 5/12`, type: 'practice', difficulty: 'medium', hints: ['To add fractions, find common denominator', 'To divide by fraction, multiply by reciprocal'], order: 1, isPublished: true },
];

// ===== MAIN SEED FUNCTION =====
async function seed() {
  console.log('Seeding ClarityCrew Firestore...\n');

  // 1. Courses
  console.log('Courses...');
  for (const c of courses) {
    await toDocRef('courses', c.id).set({ ...c, lastUpdated: Timestamp() });
    console.log(`  OK ${c.title}`);
  }

  // 2. Subjects
  console.log('\nSubjects...');
  for (const s of subjects) {
    await toDocRef('subjects', s.id).set({ ...s, lastUpdated: Timestamp() });
    console.log(`  OK ${s.title} (${s.id})`);
  }

  // Update course subjectIds
  for (const course of courses) {
    const ids = subjects.filter(s => s.courseId === course.id).map(s => s.id);
    await toDocRef('courses', course.id).update({ subjectIds: ids });
  }

  // 3. Units
  console.log('\nUnits...');
  for (const u of units) {
    await toDocRef('units', u.id).set({ ...u, lastUpdated: Timestamp() });
    console.log(`  OK ${u.title} (${u.id})`);
  }

  // Update subject unitIds
  for (const sub of subjects) {
    const ids = units.filter(u => u.subjectId === sub.id).map(u => u.id);
    await toDocRef('subjects', sub.id).update({ unitIds: ids });
  }

  // 4. Lessons
  console.log('\nLessons...');
  for (const l of lessons) {
    await toDocRef('lessons', l.id).set({ ...l, lastUpdated: Timestamp() });
    console.log(`  OK ${l.title} (${l.id})`);
  }

  // Update unit lessonIds
  for (const u of units) {
    const ids = lessons.filter(l => l.unitId === u.id).map(l => l.id);
    await toDocRef('units', u.id).update({ lessonIds: ids });
  }

  // 5. Quizzes
  console.log('\nQuizzes...');
  for (const q of quizzes) {
    const ref = toDocRef('quizzes', q.id);
    await ref.set({ lessonId: q.lessonId, createdAt: Timestamp() });
    const questionsRef = ref.collection('questions');
    for (const qq of q.questions) {
      await questionsRef.doc(qq.id).set(qq);
    }
    console.log(`  OK ${q.id}`);
  }

  // 6. Exercises
  console.log('\nExercises...');
  for (const ex of exercises) {
    await toDocRef('exercises', ex.id).set({ ...ex, lastUpdated: Timestamp() });
    console.log(`  OK ${ex.title} (${ex.id})`);
  }

  // 7. Content source record
  console.log('\nContent source...');
  await toDocRef('content_sources', 'kolibri-cbse').set({
    sourceType: 'kolibri_studio',
    sourceName: 'Kolibri CBSE Content Pack',
    sourceId: 'cbse-middle-school',
    sourceUrl: 'https://studio.learningequality.org/',
    importStatus: 'completed',
    sourceMetadata: { board: 'CBSE', grades: [6, 7, 8], description: 'CBSE curriculum content for classes 6-8' },
    importedAt: Timestamp(),
    version: 1,
    checksum: '',
  });

  // Summary
  const totalQuestions = quizzes.reduce((sum, q) => sum + q.questions.length, 0);
  console.log('\n========================================');
  console.log('Seed complete!');
  console.log(`  Courses: ${courses.length}`);
  console.log(`  Subjects: ${subjects.length}`);
  console.log(`  Units: ${units.length}`);
  console.log(`  Lessons: ${lessons.length}`);
  console.log(`  Quizzes: ${quizzes.length} (${totalQuestions} questions)`);
  console.log(`  Exercises: ${exercises.length}`);
  console.log('========================================');
}

seed().catch(err => {
  console.error('Seed failed:', err.message);
  if (err.code === 'PermissionDenied') {
    console.error('\nThe service account does not have permission for project claritycrew-aa67a.');
    console.error('Create a new key at: https://console.firebase.google.com/project/claritycrew-aa67a/settings/serviceaccounts');
    console.error('Save the JSON file as scripts/service-account.json');
  }
  process.exit(1);
});
