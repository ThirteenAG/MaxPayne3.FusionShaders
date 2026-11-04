row_major float4x4 gWorldViewProj : register(c8);
row_major float4x4 matWheelTransform : register(c64);
float4 tyreDeformParams : register(c68);
float4 tyreDeformParams2 : register(c69);
bool tyreDeformSwitchOn : register(b9);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 normal : NORMAL;
	float4 tangent : TANGENT;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	r0.xyz = matWheelTransform[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * matWheelTransform[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * matWheelTransform[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + matWheelTransform[3].xyz;
	r1.xyz = matWheelTransform[1].xyz * i.normal.yyy;
	r1.xyz = i.normal.xxx * matWheelTransform[0].xyz + r1.xyz;
	r1.xyz = i.normal.zzz * matWheelTransform[2].xyz + r1.xyz;
	r1.xyz = r1.xyz + 1E-05;
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	o.texcoord1.xyz = r0.www * r1.xyz;
	r1.xyz = matWheelTransform[1].xyz * i.tangent.yyy;
	r1.xyz = i.tangent.xxx * matWheelTransform[0].xyz + r1.xyz;
	r1.xyz = i.tangent.zzz * matWheelTransform[2].xyz + r1.xyz;
	r1.xyz = r1.xyz + 1E-05;
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	o.texcoord4 = r0.www * r1.xyz;
	if (tyreDeformSwitchOn) {
		r1.xy = i.position.yz * i.position.yz;
		r0.w = r1.y + r1.x;
		r1.x = tyreDeformParams2.x * tyreDeformParams2.x;
		r1.x = (r1.x < r0.w) ? 1 : 0;
		r1.yzw = tyreDeformParams2.www * i.position.xyz;
		r0.w = r0.w * tyreDeformParams2.w;
		r2.xyz = tyreDeformParams2.xyz;
		r2.x = r2.x * 1.1;
		r2.x = r2.x * r2.x;
		r0.w = (r2.x < r0.w) ? 1 : 0;
		r2.x = r2.y + 0.03;
		r2.y = (r0.z < r2.x) ? 1 : 0;
		r2.w = -r0.z + tyreDeformParams2.y;
		r3.x = (r2.w < 0) ? 1 : 0;
		r2.w = r3.x * -r2.w + r2.w;
		r2.x = -r0.z + r2.x;
		r3.x = r2.x * tyreDeformParams2.z;
		r3.y = (1 < r3.x) ? 1 : 0;
		r2.x = r2.x * -r2.z + 1;
		r2.x = r3.y * r2.x + r3.x;
		r3.yz = tyreDeformParams.yz * r2.ww + r1.zw;
		r2.z = tyreDeformParams.w * -r2.x + r1.y;
		r2.w = tyreDeformParams.x * i.position.x;
		r3.x = r2.w * r2.x + r2.z;
		r2.xzw = i.position.xyz * -tyreDeformParams2.www + r3.xyz;
		r2.xyz = r2.xzw * r2.yyy;
		r1.yzw = r0.www * r2.xyz + r1.yzw;
		r2.xyz = lerp(i.position.xyz, r1.yzw, r1.xxx);
	} else {
		r2.xyz = i.position.xyz;
	}
	r1.xyz = r2.yyy * matWheelTransform[1].xyz;
	r1.xyz = r2.xxx * matWheelTransform[0].xyz + r1.xyz;
	r1.xyz = r2.zzz * matWheelTransform[2].xyz + r1.xyz;
	r1.xyz = r1.xyz + matWheelTransform[3].xyz;
	r2 = r1.y * gWorldViewProj[1];
	r2 = r1.x * gWorldViewProj[0] + r2;
	r1 = r1.z * gWorldViewProj[2] + r2;
	r1 = r1 + gWorldViewProj[3];
	o.position = r1;
	o.texcoord = i.texcoord.xy;
	o.texcoord1.w = r1.w;
	o.texcoord2 = i.color.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	o.texcoord5 = i.tangent.w;
	o.texcoord6.xyz = r0.xyz;
	o.texcoord6.w = 1;

	return o;
}
