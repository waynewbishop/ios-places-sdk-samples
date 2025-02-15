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

struct PlaceCardList: View {
    @StateObject private var viewModel = CardExampleViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.places) { place in
                NavigationLink(destination: PlaceCardView(placeId: place.placeId)) {
                    HStack {
                        /*
                        Image(systemName: place.systemIcon)
                            .foregroundColor(.yellow)
                            .imageScale(.medium)
                        */
                        VStack(alignment: .leading) {
                            Text(place.name)
                                .font(.headline)
                            Text(place.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationTitle("Place Details Card ")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
