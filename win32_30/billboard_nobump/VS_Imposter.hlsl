row_major float4x4 gWorldViewProj : register(c8);
float3 imposterWorldX : register(c205);
float3 imposterWorldY : register(c206);
float3 imposterWorldZ : register(c207);

struct VS_IN
{
	float4 position : POSITION;
	float4 normal : NORMAL;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	float4 r7;
	float4 r8;
	r0 = gWorldViewProj[1] * i.position.y;
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	o.position = r0 + gWorldViewProj[3];
	r0.xyz = 1E-05 + i.normal.xyz;
	r1.xyz = normalize(r0.xyz);
	r0.x = dot(r1.xyz, float3(0.57735026, 0.57735026, -0.57735026));
	r0.x = r0.x + 1;
	r1.w = dot(r1.yxz, float3(0.57735026, -0.57735026, -0.57735026));
	r0.y = r1.w + 1;
	r1.w = dot(r1.xyz, -0.57735026);
	r1.z = dot(r1.xyz, float3(0.57735026, -0.57735026, -0.57735026));
	r2 = r1.xyxy * float4(1, 1, -1, -1) + 1;
	r0.zw = r1.wz + 1;
	r1 = max(r0, r2);
	r1.xy = max(r1.yw, r1.xz);
	r1.x = max(r1.y, r1.x);
	r3 = (r0 >= r1.x) ? 1 : 0;
	r1 = (r2 >= r1.x) ? 1 : 0;
	r4 = -r3 + 1;
	r4 = r0 * r4;
	r5 = -r1 + 1;
	r5 = r2 * r5;
	r6 = max(r4, r5);
	r6.xy = max(r6.yw, r6.xz);
	r6.x = max(r6.y, r6.x);
	r7 = (r5 >= r6.x) ? 1 : 0;
	r6 = (r4 >= r6.x) ? 1 : 0;
	r8 = -r7 + 1;
	r5 = r5 * r8;
	r8 = -r6 + 1;
	r4 = r4 * r8;
	r8 = max(r4, r5);
	r8.xy = max(r8.yw, r8.xz);
	r8.x = max(r8.y, r8.x);
	r4 = (r4 >= r8.x) ? 1 : 0;
	r5 = (r5 >= r8.x) ? 1 : 0;
	r5 = r2 * r5;
	r5.x = dot(r5, 1);
	r4 = r0 * r4;
	r4.x = dot(r4, 1);
	r4.x = r4.x + r5.x;
	r5 = r0 * r6;
	r0 = r0 * r3;
	o.texcoord2 = r3;
	r0.x = dot(r0, 1);
	o.texcoord4 = r6;
	r0.y = dot(r5, 1);
	r3 = r2 * r7;
	o.texcoord3 = r7;
	r2 = r2 * r1;
	o.texcoord1 = r1;
	r0.z = dot(r2, 1);
	r0.z = r0.x + r0.z;
	r0.x = dot(r3, 1);
	r0.w = r0.y + r0.x;
	r0.xy = -r4.xx + r0.zw;
	r0.z = r0.y + r0.x;
	r0.z = 1 / r0.z;
	o.texcoord.zw = r0.zz * r0.xy;
	o.color = i.color;
	o.texcoord.xy = i.texcoord.xy * float2(1, -1) + float2(0, 1);
	o.texcoord5 = imposterWorldX.xyz;
	o.texcoord6 = imposterWorldY.xyz;
	o.texcoord7 = imposterWorldZ.xyz;

	return o;
}
