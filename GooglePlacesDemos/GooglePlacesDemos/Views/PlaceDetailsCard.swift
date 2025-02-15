// Copyright 2024 Google LLC. All rights reserved.
//
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License. You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.

import SwiftUI
import GooglePlacesSwift


/// A SwiftUI view component that displays key place information in a card format.
/// Presents essential details like name, rating, price level, and operating hours
/// from a Place object retrieved via the GooglePlacesSwift SDK.
///
/// - Parameters:
///   - place: A `Place` object containing the details to display
///   - isOpen: Optional Boolean indicating if the place is currently open

struct PlaceDetailsCard: View {
   let place: Place
   let isOpen: Bool?
   
   var body: some View {
       VStack(alignment: .leading, spacing: 4) {
           Text(place.displayName ?? "")
               .font(.title2)
               .fontWeight(.medium)
           
           HStack(spacing: 4) {
               if let rating = place.rating {
                   Text(String(format: "%.1f", rating))
                       .fontWeight(.medium)
                   RatingStarsView(rating: Double(rating))
                   Text("(\(place.numberOfUserRatings))")
                       .foregroundColor(.secondary)
               }
           }
           
           HStack(spacing: 8) {
               if let types = place.types.first {
                    Text(types.displayString())
               }
               
               Text(String(repeating: "$", count: place.priceLevel.dollarSignCount()))
               
               let estimatedTimeOfArrival: String? = "9 min"
               if let eta = estimatedTimeOfArrival {
                   Text("•")
                   HStack(spacing: 2) {
                       Image(systemName: "car.fill")
                           .imageScale(.small)
                       Text(eta)
                   }
               }
           }
           .foregroundColor(.secondary)

           OpeningHoursView(place.currentOpeningHours, isOpen: isOpen)
           
        /*
           HStack(spacing: 16) {
               if let summary = place.editorialSummary {
                   Text(summary)
               }
           }
           .foregroundColor(.secondary)
           .font(.subheadline)
           .padding(.top, 2)
         */
       }
       .padding()
   }
    
    @ViewBuilder
    ///venue's local time zone
    private func OpeningHoursView(_ openingHours: OpeningHours?, isOpen: Bool?) -> some View {
        if let openingHours = openingHours {
            let todayHours = getCurrentDayHours(from: openingHours)
            
            HStack(spacing: 4) {
                if let isOpen = isOpen {
                    Text(isOpen ? "Open Now" : "Closed")
                        .foregroundColor(isOpen ? .green : .red)
                    if isOpen, let todayHours = todayHours {
                        Text("•")
                        if let closingTime = extractLastClosingTime(from: todayHours) {
                            Text("Closes at \(closingTime)")
                                .foregroundColor(.secondary)
                        }
                    }
                    else {
                        Text("•")
                        if let todayHours = todayHours {
                            Text(todayHours)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
    }

    private func getCurrentDayHours(from openingHours: OpeningHours) -> String? {
        // Get current weekday as a string (Monday, Tuesday, etc.)
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: Date())
        
        // Convert weekday number to name
        let weekdaySymbols = calendar.weekdaySymbols
        let todayName = weekdaySymbols[today - 1] // -1 because weekday is 1-based
        
        // Find matching hours string
        return openingHours.weekdayText.first { dayText in
            dayText.lowercased().starts(with: todayName.lowercased())
        }
    }

    private func extractLastClosingTime(from dayText: String) -> String? {
        // Split on comma to handle multiple periods
        let periods = dayText.split(separator: ",")
        if let lastPeriod = periods.last {
            // Look for the time after the last dash or en dash
            if let range = lastPeriod.range(of: "–") ?? lastPeriod.range(of: "-") {
                let closingTime = String(lastPeriod[range.upperBound...])
                    .trimmingCharacters(in: .whitespaces)
                return closingTime
            }
        }
        return nil
    }
    
}


