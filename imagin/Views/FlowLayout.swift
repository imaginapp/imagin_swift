//
//  FlowLayout.swift
//  imagin
//
//  Created by Nicholas Terrell on 28/5/2025.
//

import SwiftUI

struct FlowLayout<Data, Content>: View where Data: RandomAccessCollection, Data.Element: Hashable, Content: View {
    let items: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    
    init(
        items: Data,
        spacing: CGFloat = 4,
        alignment: HorizontalAlignment = .leading,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.items = items
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }
    
    var body: some View {
        _FlowLayout(
            items: items,
            spacing: spacing,
            alignment: alignment,
            content: content
        )
    }
}

private struct _FlowLayout<Data, Content>: View where Data: RandomAccessCollection, Data.Element: Hashable, Content: View {
    let items: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    
    @State private var itemSizes: [AnyHashable: CGSize] = [:]
    @State private var totalHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                // Invisible views to measure sizes
                ForEach(Array(items), id: \.self) { item in
                    content(item)
                        .fixedSize()
                        .opacity(0)
                        .background(
                            GeometryReader { itemGeometry in
                                Color.clear
                                    .onAppear {
                                        itemSizes[AnyHashable(item)] = itemGeometry.size
                                    }
                            }
                        )
                }
                
                // Actual visible layout
                if !itemSizes.isEmpty {
                    actualLayout(in: geometry)
                }
            }
        }
        .frame(height: totalHeight)
    }
    
    private func actualLayout(in geometry: GeometryProxy) -> some View {
        let availableWidth = geometry.size.width
        let rows = calculateRows(availableWidth: availableWidth)
        let rowWidths = calculateRowWidths(rows: rows)
        
        return VStack(alignment: .leading, spacing: spacing) {
            ForEach(0..<rows.count, id: \.self) { rowIndex in
                let row = rows[rowIndex]
                let rowWidth = rowWidths[rowIndex]
                let leadingOffset = alignment == .center ? (availableWidth - rowWidth) / 2 : 0
                
                HStack(spacing: spacing) {
                    ForEach(row, id: \.self) { item in
                        content(item)
                    }
                    Spacer(minLength: 0)
                }
                .offset(x: leadingOffset)
            }
        }
        .background(
            GeometryReader { contentGeometry in
                Color.clear
                    .onAppear {
                        totalHeight = contentGeometry.size.height
                    }
                    .onChange(of: contentGeometry.size.height) { newHeight in
                        totalHeight = newHeight
                    }
            }
        )
    }
    
    private func calculateRows(availableWidth: CGFloat) -> [[Data.Element]] {
        var rows: [[Data.Element]] = []
        var currentRow: [Data.Element] = []
        var currentRowWidth: CGFloat = 0
        
        for item in items {
            guard let itemSize = itemSizes[AnyHashable(item)] else { continue }
            
            let itemWidth = itemSize.width
            let spaceNeeded = itemWidth + (currentRow.isEmpty ? 0 : spacing)
            
            if currentRowWidth + spaceNeeded <= availableWidth || currentRow.isEmpty {
                currentRow.append(item)
                currentRowWidth += spaceNeeded
            } else {
                if !currentRow.isEmpty {
                    rows.append(currentRow)
                }
                currentRow = [item]
                currentRowWidth = itemWidth
            }
        }
        
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        
        return rows
    }
    
    private func calculateRowWidths(rows: [[Data.Element]]) -> [CGFloat] {
        return rows.map { row in
            var width: CGFloat = 0
            for (index, item) in row.enumerated() {
                if let itemSize = itemSizes[AnyHashable(item)] {
                    width += itemSize.width
                    if index < row.count - 1 {
                        width += spacing
                    }
                }
            }
            return width
        }
    }
}

#Preview {
    var words: String = "one two three four five six seven eight nine ten eleven twelve"
    VStack(spacing: 20) {
        Text("Left Aligned")
        FlowLayout(
            items: words.split(separator: " ").map(String.init),
            alignment: .leading
        ) { word in
            Text(word)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(.thinMaterial, in: Capsule())
        }
        
        Text("Centered")
        FlowLayout(
            items: words.split(separator: " ").map(String.init),
            alignment: .center
        ) { word in
            Text(word)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(.thinMaterial, in: Capsule())
        }
        
        Text("After")
    }
    .padding()
}
