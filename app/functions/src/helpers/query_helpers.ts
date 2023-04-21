import { adminApp } from "..";

export namespace QueryHelpers {
  // TODO: Fix this
  export async function queryEventWithOrWithoutRRules(
    baseQuery: FirebaseFirestore.Query,
    startRange: Date,
    endRange: Date
  ): Promise<{ docId: string; eventDate?: Date }[]> {
    const querySnapshot = await baseQuery
      //   .where("start_date", "<=", adminApp.firestore.Timestamp.fromDate(endRange))
      //   .where("end_date", ">=", adminApp.firestore.Timestamp.fromDate(startRange))
      .get();

    const events: { docId: string; eventDate?: Date }[] = [];

    querySnapshot.forEach((doc) => {
      const eventData = doc.data();

      if (eventData.rrule) {
        const rruleStr = eventData.rrule;
        const rruleStartDate = eventData.start_date.toDate();
        const rruleEndDate = eventData.end_date.toDate();

        // const rrule = rrulestr(rruleStr, { dtstart: rruleStartDate });
        // const occurrences = rrule.between(startRange, endRange, true);

        // for (const occ of occurrences) {
        //   events.push({
        //     docId: doc.id,
        //     eventDate: occ,
        //   });
        // }
      } else {
        events.push({
          docId: doc.id,
        });
      }
    });

    return events;
  }
}
