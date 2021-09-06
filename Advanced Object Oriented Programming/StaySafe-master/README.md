## Stay Safe 
#### In progress - Medical appointments system made as an assignment for Uni 

### Persistence 
- Database (MySQL)
- CSV  
Both classes implement the DataAccess interface
  
### Models
- abstract class User
- Patient, Doctor, Nurse (extend User)
- Medical Center
- Appointment
- Response (Doctor's treatment plan + more)
- Bill
- Drug

### Supported operations
* Sign Up
* Log In
* Log Out
* Search a Medical Center
* Search a Doctor
* See upcoming appointments
   * Patients, Doctors and Nurses can check their schedule
* Request an appointment
   * Patients can choose a medical center and describe their issue. After the submission, the appointment will be in 'pending' state until a nurse will process it
* See appointment history
    * Patients can view their history - needed for keeping track of previous treatments
* Process an appointment
    * Nurses read the description and assign the request to a doctor with the right specialty. Now the appointment will be in 'assigned' state
* Search a drug
    * Only available to staff members, used when giving a treatment
* Give a response
    * Staff members will give a treatment plan and a description
