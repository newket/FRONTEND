enum Genre {
  ALL('전체', 'ALL'),
  CONCERT('콘서트/팬미팅', 'CONCERT'),
  FESTIVAL('페스티벌', 'FESTIVAL'),
  MUSICAL('뮤지컬/연극', 'MUSICAL');

  final String displayName;
  final String name;

  const Genre(this.displayName, this.name);
}
