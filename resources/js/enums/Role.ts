export const Role = {
  ADMIN: 'admin',
  MANAGER: 'manager',
  USER: 'user'
} as const

export type Role = (typeof Role)[keyof typeof Role];
