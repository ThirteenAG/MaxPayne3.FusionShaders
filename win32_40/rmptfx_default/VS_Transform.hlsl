cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer rage_ptx : register(b3)
{
	float4 gForcedColor : packoffset(c0);
	float4 gAspectRatio : packoffset(c1);
};

cbuffer Hybrid : register(b2)
{
	float HybridAdd : packoffset(c0);
	float gBiasToCamera : packoffset(c0.y);
};

cbuffer ParticleSprite : register(b4)
{
	float4 gTexCoordScaleOffset : packoffset(c0);
};

struct VS_IN
{
	float4 position : POSITION;
	float3 normal : NORMAL;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
};

struct VS_OUT
{
	float4 color : COLOR;
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float2 r2;
	float r3;
	o.color = i.color;
	r0.xyz = -(i.position.xyz) + gViewInverse[3].xyz;
	r0.w = gBiasToCamera * 0.100000001;
	r0.xyz = r0.xyz * r0.www + i.position.xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r0 = r0.z * gWorldViewProj[2] + r1;
	r0 = r0 + gWorldViewProj[3];
	r1.zw = float2(0, 0);
	r2.x = sin(i.normal.z);
	r3 = cos(i.normal.z);
	r2 = r2.xx * i.normal.yx;
	r1.x = i.normal.x * r3.x + -(r2.x);
	r1.y = i.normal.y * r3.x + r2.y;
	o.sv_position = r1 * gAspectRatio + r0;
	o.texcoord = i.texcoord * gTexCoordScaleOffset.xyxy + gTexCoordScaleOffset.zwzw;
	o.texcoord1 = i.texcoord1;
	o.texcoord2.x = i.texcoord2.z;
	o.texcoord2.yzw = float3(0, 0, 0);
	o.texcoord3 = i.texcoord3;
	o.texcoord4 = i.texcoord4;

	return o;
}
