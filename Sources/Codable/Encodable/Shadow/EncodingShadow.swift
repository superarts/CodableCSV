/// The instance actually performing all CSV encoding work.
///
/// A shadow encoder represents a moment in time on the encoding process. Therefore it is an immutable structure.
internal struct ShadowEncoder: Encoder {
    /// The sink of the CSV values.
    let sink: Sink
    /// The path of coding keys taken to get to this point of the encoding.
    let codingPath: [CodingKey]
    /// Any contextual information set by the user for encoding.
    var userInfo: [CodingUserInfoKey:Any] { self.sink.userInfo }
    
    /// Designated initializer passing all required components.
    init(sink: Sink, codingPath: [CodingKey]) {
        self.sink = sink
        self.codingPath = codingPath
    }
}

extension ShadowEncoder {
    /// Returns an encoding container appropriate for holding multiple values keyed by the given key type.
    ///
    /// You must use only one kind of top-level encoding container. This method must not be called after a call to `unkeyedContainer()` or after encoding a value through a call to `singleValueContainer()`.
    /// - parameter type: The key type to use for the container.
    /// - returns: A new keyed encoding container.
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        KeyedEncodingContainer<Key>(KeyedContainer(encoder: self))
    }
    
    /// Returns an encoding container appropriate for holding multiple unkeyed values.
    ///
    /// You must use only one kind of top-level encoding container. This method must not be called after a call to `container(keyedBy:)` or after encoding a value through a call to `singleValueContainer()`.
    /// - returns: A new empty unkeyed container.
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        UnkeyedContainer(encoder: self)
    }
    
    /// Returns an encoding container appropriate for holding a single primitive value.
    ///
    /// You must use only one kind of top-level encoding container. This method must not be called after a call to `unkeyedContainer()` or `container(keyedBy:)`, or after encoding a value through a call to singleValueContainer()
    /// - returns: A new empty single value container.
    func singleValueContainer() -> SingleValueEncodingContainer {
        SingleValueContainer(encoder: self)
    }
}
